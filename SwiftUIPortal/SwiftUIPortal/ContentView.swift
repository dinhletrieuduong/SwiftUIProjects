//
//  ContentView.swift
//  SwiftUIPortal
//
//  Created by Dylan on 14/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    let total = 6
    @State var completed = 0
    let lineWidth: CGFloat = 16
    
    var body: some View {
//        if networkMonitor.isConnected {
//            VStack {
//                CircularProgressBarView(total: total, completed: completed, lineWidth: lineWidth, color: .green)
//                Button {
//                    withAnimation {
//                        guard completed < total else {
//                            completed = 0
//                            return
//                        }
//                        completed += 1
//                    }
//                } label: {
//                    Text("Finish next step")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                }
//                .padding(.vertical)
//            }
//            .padding()
//        }
//        else {
            DetectNetworkContentView()
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
