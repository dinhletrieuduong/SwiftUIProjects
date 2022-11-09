//
//  ContentView.swift
//  DetectInternetSwiftUI
//
//  Created by LAP14482 on 24/09/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var monitor = NetworkMonitor()
    @State private var showAlertSheet = false
    
    var body: some View {
        VStack{
            Image(systemName: monitor.isConnected ? "wifi" : "wifi.slash")
                .font(.system(size: 56))
            Text(monitor.isConnected ? "Connected!" : "No connected!")
                .padding()
            
            Button("Perform Network Request") {
                self.showAlertSheet = true
            }
        }
        .alert(isPresented: $showAlertSheet, content: {
            if monitor.isConnected {
                return Alert(title: Text("Success!"), message: Text("The network request can be performed!"), dismissButton: .default(Text("Ok")))
            }
            return Alert(title: Text("No internet connection!"), message: Text("Please enable Wifi or Cellular data!"), dismissButton: .default(Text("Cancel")))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
