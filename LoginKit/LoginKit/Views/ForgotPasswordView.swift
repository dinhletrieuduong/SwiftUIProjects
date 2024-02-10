//
//  ForgotPasswordView.swift
//  LoginKit
//
//  Created by Dinh Le Trieu Duong on 06/02/2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Binding var showResetView: Bool
    
    /// View properties
    @State private var email: String = ""
    
    /// Environment properties
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 10)
            
            Text("Forgot Password?")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            Text("Please enter your Email so that we can send the reset link.")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                CustomTextField(sfIcon: "at", hint: "Email", isPassword: false, value: $email)
                
                GradientButton(title: "Send Link", icon: "arrow.right") {
                    Task {
                        dismiss()
                        try? await Task.sleep(for: .seconds(0))
                        
                        showResetView = true
                    }
                }
                .hSpacing(.trailing)
                .disableWithOpacity(email.isEmpty)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 15)
        .interactiveDismissDisabled()
    }
}

#Preview {
    ContentView()
}
