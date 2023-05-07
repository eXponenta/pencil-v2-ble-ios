//
//  Service.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 07.05.2023.
//

import Foundation
import CoreBluetooth

protocol Service: ObservableObject {
    var UUID: CBUUID { get };
    
    var CHARACTERISTICS_UUID: [CBUUID] { get };
    
    var characteristics: [CBCharacteristic] { get };

    var active: Bool { get };
    
    var needsRead: Bool { get };

    func start( characteristics: [CBCharacteristic] ) -> Void;

    func stop() -> Void;
    
    func update(characteristic: CBCharacteristic) -> Void;
    
    func queryRead(poll : (CBCharacteristic) -> Void) -> Void;

    /*
    private let bulkDataCharacteristicUUID = CBUUID(string: "9eae1001-9d0d-48c5-AA55-33e27f9bc533")
    private var bulkDataCharacteristic: CBCharacteristic?
    private let bulkDataServiceUUID =
    private let settingsServiceUUID = CBUUID(string: "f6d80000-5a10-4eba-aa55-33e27f9bc533")
    private var setpointCharacteristic: CBCharacteristic?
    private var setpointCharacteristicUUID = CBUUID(string: "f6d70000-5a10-4eba-aa55-33e27f9bc533")
     */
}
