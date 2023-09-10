//
//  OtpVerificationView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI

struct OtpVerificationView: View {
    @State var otpText: String = ""
    let otpCount: Int = 7
    // Keyboard State
    @FocusState private var isKeyboardShowing: Bool
    
    var body: some View {
        VStack {
//            Text("Verify OTP")
//                .font(.largeTitle.bold())
//                .hLeading()
//            
            HStack(spacing: 0) {
                ForEach(0..<otpCount, id: \.self) { i in
                    creatOtpTextBox(i)
                }
            }
            .background(content: {
                TextField("", text: $otpText.limit(otpCount))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 1, height: 1)
                    .opacity(0.001)
                    .blendMode(.screen)
                    .focused($isKeyboardShowing)
                
            })
            .contentShape(Rectangle())
            .onTapGesture {
                // Open keyboard when tapped
                isKeyboardShowing.toggle()
                
            }
            .padding(.bottom, 20)
            .padding(.top, 10)
            
            
            Button {
                
            } label: {
                Text("Verify")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(.blue)
                    }
            }
            .disableWithOpacity(otpText.count < otpCount)
        }
        .padding(.all)
        .vTop()
        .toolbar(content: {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isKeyboardShowing.toggle()
                }
                .hTrailing()
            }
        })
    }
    
    // MARK: OTP Text Box
    func creatOtpTextBox(_ index: Int) -> some View {
        ZStack {
            if otpText.count > index {
                // Finding char at index
                let startIndex = otpText.startIndex
                let charIndex = otpText.index(startIndex, offsetBy: index)
                let charToString = String(otpText[charIndex])
                Text(charToString)
            } else {
                Text("")
            }
        }
        .frame(width: 45, height: 45)
        .background {
            // Highlight current active box
            let status = isKeyboardShowing && otpText.count == index
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? .black : .gray, lineWidth: 0.5)
                .animation(.easeInOut(duration: 0.2), value: status)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: Binding <String> Extension
extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        
        return self
    }
}
