//
//  PasswordResetView.swift
//  LoginKit
//
//  Created by Dinh Le Trieu Duong on 06/02/2024.
//

import SwiftUI

struct PasswordResetView: View {
    /// View properties
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    /// Environment properties
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 10)
            
            Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            VStack(spacing: 25) {
                CustomTextField(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                
                CustomTextField(sfIcon: "lock", hint: "Confirm Password", isPassword: true, value: $confirmPassword)
                    .padding(.top, 5)
                
                GradientButton(title: "Continue", icon: "arrow.right") {
                    
                }
                .hSpacing(.trailing)
                .disableWithOpacity(password.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
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
