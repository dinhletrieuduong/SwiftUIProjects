//
//  ContentView.swift
//  LoginKit
//
//  Created by Dinh Le Trieu Duong on 06/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    /// View properties
    @State private var showSignUp: Bool = false
    
    /// Keyboard
    @State private var isKeyboardShowing: Bool = false
    
    var body: some View {
        NavigationStack {
            LoginView(showSignUp: $showSignUp)
                .navigationDestination(isPresented: $showSignUp) {
                    SignUpView(showSignUp: $showSignUp)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                    if showSignUp { return }
                    isKeyboardShowing = true
                })
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                    isKeyboardShowing = false
                })
        }
        .overlay {
            /// iOS 17 Bounce Animation
            if #available(iOS 17, *) {
                CircleView()
                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignUp)
                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: isKeyboardShowing)
            } else {
                CircleView()
                    .animation(.easeInOut(duration: 0.3), value: showSignUp)
                    .animation(.easeInOut(duration: 0.3), value: isKeyboardShowing)
            }
            
        }
        
    }
    
    /// Moving Blurred Background
    @ViewBuilder
    func CircleView() -> some View {
        Circle()
            .fill(.linearGradient(colors: [.appYellow, .orange, .red], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height: 200)
            .offset(x: showSignUp ? 90 : -90, y: -90 - (isKeyboardShowing ? 200 : 0))
            .blur(radius: 15)
            .hSpacing(showSignUp ? .trailing : .leading)
            .vSpacing(.top)
    }
    
    
    
    
    
}

#Preview {
    ContentView()
}
