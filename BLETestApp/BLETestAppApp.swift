//
//  BLETestAppApp.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 06.05.2023.
//

import SwiftUI


@main
struct BLETestAppApp: App {
    @StateObject var state: AppState = AppState();

    init() {
        
    }

    var body: some Scene {
        WindowGroup(id: "main") {
            ContentView()
                .environmentObject(state)
        }
    }
}
