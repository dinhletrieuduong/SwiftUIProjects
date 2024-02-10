//
//  OTPView.swift
//  LoginKit
//
//  Created by Dinh Le Trieu Duong on 06/02/2024.
//

import SwiftUI

struct OTPView: View {
    @Binding var otpText: String
    
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
            .padding(.top, 15)
            
            Text("Enter OTP")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            Text("An 6 digits code has been sent to your Email")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                OtpVerificationView(otpText: $otpText)
                
                GradientButton(title: "Continue", icon: "arrow.right") {
                    
                }
                .hSpacing(.trailing)
                .disableWithOpacity(otpText.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 15)
        .interactiveDismissDisabled()
    }
}

#Preview {
    ContentView()
}

