//
//  AppState.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 06.05.2023.
//

import Foundation

class AppState: ObservableObject {
    @Published var currentTemp: UInt32 = 0;
    @Published var maxTemp: UInt32 = 0;
    @Published var targetTemp: UInt32 = 0;
    @Published var handleTemp: UInt32 = 0;
    
    init() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true);
    }

    @objc func update() {
        currentTemp = .random(in: 0...200);
        maxTemp = max(maxTemp, currentTemp);
    }
}

