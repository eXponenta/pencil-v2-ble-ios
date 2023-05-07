//
//  BulkData.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 07.05.2023.
//

import Foundation

/// See https://github.com/Ralim/IronOS/blob/5a36b0479cef995ecfb1e75638579d11cb891feb/source/Core/BSP/Pinecilv2/ble_handlers.cpp#L151-L166
struct BulkData {
    /// Current temp
    var tipTemp: UInt32 = 0
    /// Setpoint
    var targetTemp: UInt32 = 0
    /// Input voltage
    var inputVoltage: UInt32 = 0
    /// Handle X10 Temp in C
    var handleTemp: UInt32 = 0
    /// Power as PWM level
    var powerPWM: UInt32 = 0
    /// Power src
    var powerSource: UInt32 = 0
    /// Tip resistance
    var tipResistance: UInt32 = 0
    /// Uptime in deciseconds
    var uptime: UInt32 = 0
    /// Last movement time (deciseconds)
    var lastMovementTime: UInt32 = 0
    /// Max temp
    var maxTemperature: UInt32 = 0
    /// Raw tip in μV
    var rawTipMicrovolts: UInt32 = 0
    /// Hall sensor
    var hallSensor: UInt32 = 0
    /// Operating mode
    var operatingMode: UInt32 = 0
    /// Estimated wattage × 10
    var estimatedWattage: UInt32 = 0
    
    static func decode(data: Data) -> BulkData? {
        guard data.count >= 56 else {
            assertionFailure()
            return nil
        }
 
        return data.withUnsafeBytes { buffer in
            buffer.load(as: BulkData.self)
        }
    }
}
