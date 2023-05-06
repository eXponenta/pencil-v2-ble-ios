//
//  ContentView.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 06.05.2023.
//

import SwiftUI

struct ContentView: View {
    @State var showModal = false;

    var body: some View {
        NavigationView {
            MainTempView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: pair) {
                          Label("Pair", systemImage: "wifi.slash")
                          Text("Connected")
                      }.foregroundColor(.green)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                      Button(action: open_config) {
                        Label("Config", systemImage: "gearshape.fill")
                      }
                    }
                }.sheet(isPresented: self.$showModal) {
                    NavigationView{
                        Text("Test")
                            .toolbar {
                                ToolbarItem(placement:.navigationBarLeading) {
                                    Button(action: close_config) {
                                        Image(systemName: "arrow.backward");
                                        Text("Back")
                                    }
                                }
                            }
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func pair() {
        print("pair");
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
