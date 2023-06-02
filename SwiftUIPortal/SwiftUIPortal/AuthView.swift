//
//  AuthView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI
import LocalAuthentication

struct AuthView: View {
    @State var unlocked = false
    var body: some View {
        VStack {
            if unlocked {
                ZStack {
                    Color(.green).edgesIgnoringSafeArea(.all)
                    Text("Unlocked")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
            } else {
                ZStack {
                    Color(.red).edgesIgnoringSafeArea(.all)
                    
                    Text("Locked")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
            }
        }
        .onAppear(perform: {
            //            authenticate()
        })
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Use FaceID tounlock the app"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    self.unlocked = true
                }
                else {
                    // not unlocked
                }
            }
        } else {
            // phones does not have FaceID or TouchID
        }
    }
}
