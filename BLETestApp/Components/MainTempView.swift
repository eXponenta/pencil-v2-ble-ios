//
//  MainTempView.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 06.05.2023.
//

import SwiftUI

struct MainTempView: View {
    @EnvironmentObject var state: AppState;

    var body: some View {
        VStack(alignment: .leading) {
            // Current Pen temperature
            VStack(alignment: .leading) {
                Text("Tip:")
                    .font(.system(size: 40))
                HStack {
                    Text("\(state.currentTemp)")
                        .frame(maxWidth: 140, alignment: .trailing)
                    Text("°C")
                        .frame(
                            alignment: .trailing
                        )
                }.font(.system(size: 72))
                    .bold()
                    .monospaced()

            }.frame(alignment: .leading)

            VStack(alignment: .trailing) {
                HStack() {
                    Text("Target:")
                    Text("\(state.targetTemp)°C")
                }
                HStack() {
                    Text("Handle:")
                    Text("\(state.handleTemp)°C")
                }
            }
                .font(.system(size: 24))
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
        }
        .padding(16)
        .textCase(.uppercase)
        .frame(maxWidth: 380)
    }
}

struct MainTempView_Previews: PreviewProvider {
    static var previews: some View {
        MainTempView().environmentObject(AppState())
    }
}
