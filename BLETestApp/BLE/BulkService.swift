//
//  BulkService.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 07.05.2023.
//

import Foundation
import CoreBluetooth;

class BulkService: Service {
    
    var CHARACTERISTICS_UUID = [CBUUID(string: "9eae1001-9d0d-48c5-AA55-33e27f9bc533")];

    var UUID = CBUUID(string: "9eae1000-9d0d-48c5-aa55-33e27f9bc533");

    var characteristics: [CBCharacteristic] = [];

    var active: Bool = false;

    var needsRead: Bool = true;

    func stop() {
        active = false;
    }

    
    func start(characteristics: [CBCharacteristic]) {
        self.characteristics = characteristics;

        active = true;
        
        print("Start service");
    }
    
    func queryRead(poll: (CBCharacteristic) -> Void) {
        if self.characteristics.count == 0 {
            return;
        }
        
        print("Query read")

        self.characteristics.forEach {
            poll($0);
        }
        
    }

    func update(characteristic: CBCharacteristic) {
        guard let raw = characteristic.value else {
            return
        }
        
        print(raw);
    }
}
