//
//  ContentView.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 06.05.2023.
//

import SwiftUI

import CoreBluetooth;

struct ContentView: View {
    @State var showModal = false;
    
    @State var showList = false;
    
    @EnvironmentObject var appState: AppState;
    
    var body: some View {
        NavigationView {
                MainTempView(data: appState.bulkService)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: pair) {
                            Label("Pair", systemImage: "wifi.slash")
                            
                            if case .connected(_) = appState.bleService.state {
                                Text( "Connected")
                            } else {
                                Text( "Not connected")
                            }
                        }.foregroundColor(.green)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: open_config) {
                            Label("Config", systemImage: "gearshape.fill")
                        }
                    }
                }.sheet(isPresented: self.$showModal) {
                    NavigationView{
                        VStack(alignment: .leading) {
                            Text("Device SN: \(appState.bulkService.serial)");
                            Text("OS Version: \(appState.bulkService.osVersion)");
                        }.toolbar {
                                ToolbarItem(placement:.navigationBarLeading) {
                                    Button(action: close_config) {
                                        Image(systemName: "arrow.backward");
                                        Text("Back")
                                    }
                                }
                            }
                    }
                }.sheet(isPresented: self.$showList) {
                    Section("Devices") {
                        List {
                            ForEach(appState.bleService.discoveredPeripherals, id: \.name) { peripheral in
                                Button() {
                                    connect(to: peripheral);
                                } label: {
                                    Text(appState.bleService.peripheralNames[peripheral] ?? "Unknown")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func connect(to perepheral: CBPeripheral) {
        appState.bleService.connect(to: perepheral);

        self.showList = false;
    }

    func pair() {
        appState.bleService.scan();

        self.showList.toggle();
    }
    
    func close_config() {
        showModal = false;
    }
    func open_config() {
        showModal = true;
        print("config");
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState())
    }
}
