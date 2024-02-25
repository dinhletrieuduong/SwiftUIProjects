//
//  CustomTextFieldView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 24/02/2024.
//

import SwiftUI

struct CustomTextFieldView: View {
    
    @Binding var text: String
    let placeholder: String
    
    @FocusState var focused: Bool
    
    var body: some View {
        let isActive = focused || text.count > 0
        
        ZStack(alignment: isActive ? .topLeading : .center) {
            TextField("", text: $text)
                .frame(height: 24)
                .font(.system(size: 16, weight: .regular))
                .opacity(isActive ? 1 : 0)
                .offset(y: 7)
                .focused($focused)
            
            HStack {
                Text(placeholder)
                    .foregroundColor(.black.opacity(0.3))
                    .frame(height: 16)
                    .font(.system(size: isActive ? 12 : 16, weight: .regular))
                    .offset(y: isActive ? -7 : 0)
                Spacer()
            }
        }
        .onTapGesture {
            focused = true
        }
        .animation(.linear(duration: 0.2), value: focused)
        .frame(height: 56)
        .padding(.horizontal, 16)
        .background(.white)
        .cornerRadius(12)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(focused ? .black.opacity(0.6) : .black.opacity(0.2), lineWidth: 2)
        }
    }
}

struct CustomTextFieldDemoView: View {
    
    @State var text = ""
    @FocusState var focused: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("AA")
            CustomTextFieldView(text: $text, placeholder: "Enter Name")
                .padding()
                
            
            Spacer()
        }
        .removeFocusOnTap()
        .onTapGesture {
            
        }
    }
    
}

#Preview(body: {
    CustomTextFieldDemoView()
})

extension View {
    public func removeFocusOnTap() -> some View {
        modifier(RemoveFocusOnTapModifier())
    }
}

public struct RemoveFocusOnTapModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
#if os (iOS)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
            }
#elseif os(macOS)
            .onTapGesture {
                DispatchQueue.main.async {
                    NSApp.keyWindow?.makeFirstResponder(nil)
                }
            }
#endif
    }
}
