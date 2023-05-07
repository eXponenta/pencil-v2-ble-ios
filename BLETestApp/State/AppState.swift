//
//  AppState.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 06.05.2023.
//

import Foundation
import Combine

class AppState: ObservableObject {

    @Published private(set) var bleService: BLEManager = BLEManager()
    
    @Published private(set) var bulkService: BulkService = BulkService();

    var cancel: AnyCancellable?;
    var cancel2: AnyCancellable?;
    
    init() {
        // not working wihout this
        self.cancel = bulkService.objectWillChange.sink { [weak self] in
            self?.objectWillChange.send();
        }

        // not working wihout this
        self.cancel2 = bleService.objectWillChange.sink { [weak self] in
            self?.objectWillChange.send();
        }

        bleService.attach(service: self.bulkService);
    }
}

