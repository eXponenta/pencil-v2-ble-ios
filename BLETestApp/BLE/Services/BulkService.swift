//
//  BulkService.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 07.05.2023.
//

import Foundation
import CoreBluetooth;

class BulkService: ObservableObject, Service {
    
    enum CHAR_ID: Int {
        case DATA = 0
        case BUILD = 1
        case DEV_SN = 2
        case DEV_ID = 3
    }

    private(set) var CHARACTERISTICS_UUID = [
        CBUUID(string: "9eae1001-9d0d-48c5-AA55-33e27f9bc533"), // bulk
        CBUUID(string: "9eae1003-9d0d-48c5-AA55-33e27f9bc533"), // build
        CBUUID(string: "9eae1004-9d0d-48c5-AA55-33e27f9bc533"), // dev sn
        // CBUUID(string: "9eae1005-9d0d-48c5-AA55-33e27f9bc533")  // dev id
    ];

    private(set) var UUID = CBUUID(string: "9eae1000-9d0d-48c5-aa55-33e27f9bc533");

    private(set) var characteristics: [CBCharacteristic] = [];

    private(set) var active: Bool = false;

    private(set) var needsRead: Bool = true;
    
    @Published private(set) var data: BulkData = BulkData();
    
    @Published private(set) var osVersion: String = "";
    
    @Published private(set) var serial: String = "";
    
    private var serialQueried = false;

    func stop() {
        active = false;
        self.data = BulkData();
    }

    
    func start(characteristics: [CBCharacteristic]) {
        self.characteristics = characteristics;
        
        print(characteristics.map{ $0.uuid.uuidString });

        active = true;
    }
    
    func queryRead(poll: (CBCharacteristic) -> Void) {
        if self.characteristics.count == 0 {
            return;
        }

        // data
        poll(self.characteristics[CHAR_ID.DATA.rawValue]);
        
        if (!serialQueried) {
            poll(self.characteristics[CHAR_ID.BUILD.rawValue]);
            poll(self.characteristics[CHAR_ID.DEV_SN.rawValue]);
            
            serialQueried = true;
            // poll(self.characteristics[CHAR_ID.DEV_ID.rawValue]);
        }
        
    }

    func update(characteristic: CBCharacteristic) {
        guard let raw = characteristic.value else {
            return
        }

        // DATA
        if characteristic.uuid.isEqual(CHARACTERISTICS_UUID[CHAR_ID.DATA.rawValue]) {
            guard let newData = BulkData.decode(data: raw) else {
                return;
            }
            
            data = newData;
        }
        
        if characteristic.uuid.isEqual(CHARACTERISTICS_UUID[CHAR_ID.BUILD.rawValue]) {
            osVersion = String(data: raw, encoding: .utf8)!;
            
            print("Read os version:", osVersion);
        }
        
        if characteristic.uuid.isEqual(CHARACTERISTICS_UUID[CHAR_ID.DEV_SN.rawValue]) {
            let u64: UInt64 = raw.withUnsafeBytes { buffer in
                buffer.load(as: UInt64.self);
            }

            serial = String(format: "%llx", u64.littleEndian);
            serial = "".padding(toLength: 16 - serial.count, withPad: "0", startingAt: 0) + serial;

            print("Read SN:", self.serial);
        }

    }
}
