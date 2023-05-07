//
//  MainTempView.swift
//  BLETestApp
//
//  Created by Константин Тимошенко on 06.05.2023.
//

import SwiftUI

struct MainTempView: View {
    @ObservedObject var data: BulkService;

    var body: some View {
        VStack(alignment: .leading) {
            // Current Pen temperature
            VStack(alignment: .leading) {
                Text("Tip:")
                    .font(.system(size: 40))
                HStack {
                    Text("\(data.data.tipTemp)")
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
                    Text("\(data.data.targetTemp)°C")
                }
                HStack() {
                    Text("Handle:")
                    Text(String(format: "%.1f°C",Float(data.data.handleTemp) / 10.0))
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
        MainTempView(data: BulkService())
    }
}
