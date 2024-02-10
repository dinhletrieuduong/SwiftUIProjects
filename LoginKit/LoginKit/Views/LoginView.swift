//
//  LoginView.swift
//  LoginKit
//
//  Created by Dinh Le Trieu Duong on 06/02/2024.
//

import SwiftUI

struct LoginView: View {
    @Binding var showSignUp: Bool
    
    /// View properties
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var showForgotPassword: Bool = false
    
    /// Reset password
    @State private var showResetView: Bool = false
    
    /// OTP
    @State private var askOTP: Bool = false
    @State private var otpText: String = ""
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer(minLength: 0)
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please sign in to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                CustomTextField(sfIcon: "at", hint: "Email", isPassword: false, value: $email)
                
                CustomTextField(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                    .padding(.top, 5)
                
                Button("Forgot Password?") {
                    showForgotPassword = true
                }
                .font(.callout)
                .fontWeight(.heavy)
                .tint(.appYellow)
                .hSpacing(.trailing)
                
                GradientButton(title: "Login", icon: "arrow.right") {
                    askOTP.toggle()
                }
                .hSpacing(.trailing)
                .disableWithOpacity(email.isEmpty || password.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("Don't have an account?")
                
                Button("Sign Up") {
                    showSignUp = true
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
        .sheet(isPresented: $showForgotPassword, content: {
            if #available(iOS 16.4, *) {
                ForgotPasswordView(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPasswordView(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 16.4, *) {
                PasswordResetView()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                PasswordResetView()
                    .presentationDetents([.height(350)])
            }
        })
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
