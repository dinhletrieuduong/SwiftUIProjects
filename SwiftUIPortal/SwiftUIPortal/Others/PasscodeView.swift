//
//  PasscodeView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 06/02/2024.
//

import SwiftUI

struct PasscodeDemoView: View {
    @State private var isAuthenticated: Bool = false
    var body: some View {
        VStack {
            if isAuthenticated {
                VStack {
                    Text("You are in!")
                    
                    Button("Log out") {
                        isAuthenticated = false
                    }
                }
            } else {
                PasscodeView(isAuthenticated: $isAuthenticated)
            }
        }
        .padding()
    }
}

struct PasscodeView: View {
    @Binding  var isAuthenticated: Bool
    @State private var passcode: String = ""
    
    var body: some View {
        VStack(spacing: 48) {
            VStack(spacing: 24) {
                Text("Enter Passcode")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text("Please enter your 4-digit pin to securely access your account")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
            }
            .padding(.top)
            
            /// Indicator View
            PasscodeIndicatorView(passcode: $passcode)
            
            Spacer()
            
            /// NumberPad View
            NumberPadView(passcode: $passcode)
        }
        .onChange(of: passcode) { oldValue, newValue in
            verifyPasscode()
        }
    }
    
    private func verifyPasscode() {
        guard passcode.count == 4 else { return }
        Task {
            try? await Task.sleep(for: .seconds(0.125))
            isAuthenticated = passcode == "1234"
            passcode = ""
        }
    }
}

// MARK: NumberPadView
struct NumberPadView: View {
    @Binding var passcode: String
    
    let columns: [GridItem] = [
        .init(),
        .init(),
        .init(),
    ]
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(1...9, id: \.self) { number in
                Button {
                    addValue("\(number)")
                } label: {
                    Text("\(number)")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .contentShape(.rect)
                }
            }
            
            Button {
                removeValue()
            } label: {
                Image(systemName: "delete.backward")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .contentShape(.rect)
            }
            
            Button {
                addValue("0")
            } label: {
                Text("0")
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .contentShape(.rect)
            }
        }
        .foregroundStyle(.primary)
    }
    
    private func addValue(_ value: String) {
        if passcode.count >= 4 { return }
        passcode += value
    }
    
    private func removeValue() {
        if passcode.isEmpty { return }
        passcode.removeLast()
    }
}

// MARK: PasscodeIndicatorView
struct PasscodeIndicatorView: View {
    @Binding var passcode: String
    
    var body: some View {
        HStack(spacing: 32) {
            ForEach(0..<4, id: \.self) { index in
                Circle()
                    .fill(passcode.count > index ? .primary : Color.white)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Circle()
                            .stroke(.black, lineWidth: 1)
                    }
            }
        }
    }
}

#Preview {
    PasscodeDemoView()
}
