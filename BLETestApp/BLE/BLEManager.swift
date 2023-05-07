//
//  BLEManager.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 07.05.2023.
//

import Foundation
import CoreBluetooth;

class BLEManager: NSObject, ObservableObject {
    enum ConnectionState: Equatable {
        case connected(CBPeripheral)
        case connecting(CBPeripheral)
        case disconnected
        case scanning
    }
    
    private var centralManager: CBCentralManager;
    
    public var bulkService: BulkService = BulkService();
    
    private var services: [any Service] = [];
    
    private var pollTimer: Timer?;
    
    @Published var discoveredPeripherals: [CBPeripheral] = [];
    
    @Published var peripheralNames: [CBPeripheral: String] = [:];
    
    @Published var state: ConnectionState = .disconnected;
    
    override init() {
        self.centralManager = CBCentralManager();
        
        self.services.append(self.bulkService);
        
        super.init()
        
        self.centralManager.delegate = self;
    }
    
    func scan() {
        guard !centralManager.isScanning else { return }
        
        self.state = .scanning
        
        discoveredPeripherals = []
        
        peripheralNames = [:]
        
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    func stopScan() {
        centralManager.stopScan()
        
        if self.state == .scanning {
            self.state = .disconnected
        }
    }
    
    func connect(to peripheral: CBPeripheral) {
        guard self.state == .scanning else { return }
        
        self.state = .connecting(peripheral)
        
        print("Connnect", peripheral);

        centralManager.connect(peripheral)
    }
    
    func disconnect() {
        if case .connected(let peripheral) = state {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    @objc private func updateData() {
        
        guard case .connected(let cBPeripheral) = state else {
            return
        }

        for service in services {
            if service.active && service.needsRead {
                service.queryRead { CBCharacteristic in
                    cBPeripheral.readValue(for: CBCharacteristic)
                }
            }
        }
    
    }
    
    private func clear() {
        for service in services {
            service.stop()
        }
    }
}

extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            self.state = .disconnected
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
        guard let bleServices = advertisementData["kCBAdvDataServiceUUIDs"] as? [CBUUID] else {
            return
        }
        
        guard !discoveredPeripherals.contains(peripheral) else {
            return;
        }

        var attachPereferal = true;
        
        for service in services {
            attachPereferal = attachPereferal && bleServices.contains(service.UUID);
        }

        if attachPereferal {
            discoveredPeripherals.append(peripheral)

            peripheral.delegate = self
            
            // Advertised local names can be disambiguated
            // (e.g. `Pinecil-00ABCFF` vs `Pinecil`), and so we'll prefer to use
            // them over the peripheral's name property.
            if let localName = advertisementData["kCBAdvDataLocalName"] as? String {
                peripheralNames[peripheral] = localName
            } else {
                peripheralNames[peripheral] = peripheral.name
            }
        }
    }
    
    
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        clear()
        self.state = .connected(peripheral)
        
        // Search for services
        let UUIDS = services.map{ $0.UUID };

        peripheral.discoverServices(UUIDS);
        
        print("Connect", peripheral);
        
        // Start polling
        pollTimer?.invalidate()
        pollTimer = Timer.scheduledTimer(
            timeInterval: 0.2,
            target: self,
            selector: #selector(updateData),
            userInfo: nil,
            repeats: true
        )
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    ) {
        self.state = .disconnected
        print("Dissconnect", peripheral);

        clear()
        pollTimer?.invalidate()
        pollTimer = nil
    }
}

extension BLEManager: CBPeripheralDelegate {
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?
    ) {
        peripheral.services?.forEach {
            peripheral.discoverCharacteristics(nil, for: $0)
        }
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        guard let UUID = characteristic.service?.uuid else {
            return;
        }
        
        if let implService = services.first( where: { $0.UUID.isEqual(UUID) } ) {
            if implService.characteristics.contains(characteristic) {
                implService.update(characteristic: characteristic);
            }
        }
        
    }
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    ) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        guard let serviceImpl = services.first(where: {  $0.UUID.isEqual(service.uuid)})  else {
            return;
        }

        print("discover chars", characteristics);

        let activeCharacteristics = characteristics.filter { serviceImpl.CHARACTERISTICS_UUID.contains($0.uuid) };
        
        serviceImpl.start(characteristics: activeCharacteristics)
        
    }
}
