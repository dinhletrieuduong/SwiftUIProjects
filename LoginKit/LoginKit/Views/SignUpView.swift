//
//  SignUpView.swift
//  LoginKit
//
//  Created by Dinh Le Trieu Duong on 06/02/2024.
//

import SwiftUI

struct SignUpView: View {
    @Binding var showSignUp: Bool
    
    /// View properties
    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    /// OTP
    @State private var askOTP: Bool = false
    @State private var otpText: String = ""
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                showSignUp = false
            } label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 10)
            
            Text("Signup")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            Text("Please sign up to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                CustomTextField(sfIcon: "at", hint: "Email", isPassword: false, value: $email)
                
                CustomTextField(sfIcon: "person", hint: "Full Name", isPassword: false, value: $fullName)
                    .padding(.top, 5)
                
                CustomTextField(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                    .padding(.top, 5)
                
                CustomTextField(sfIcon: "lock", hint: "Confirm Password", isPassword: true, value: $confirmPassword)
                    .padding(.top, 5)
                
                GradientButton(title: "Continue", icon: "arrow.right") {
                    askOTP = true
                }
                .hSpacing(.trailing)
                .disableWithOpacity(email.isEmpty || fullName.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("Already have an account?")
                
                Button("Login") {
                    showSignUp = false
                }
                .fontWeight(.bold)
                .tint(.appYellow)
            }
            .font(.callout)
            .hSpacing()
            
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 15)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $askOTP, content: {
            if #available(iOS 16.4, *) {
                OTPView(otpText: $otpText)
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                OTPView(otpText: $otpText)
                    .presentationDetents([.height(350)])
            }
        })
    }
}

#Preview {
    ContentView()
}
