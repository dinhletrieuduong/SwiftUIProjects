//
//  CustomButtonView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 24/02/2024.
//

import SwiftUI

struct CustomButtonDemoView: View {
    var body: some View {
        ScrollView {
            VStack {
                FillButton()
                
                BorderButton()
                
                HStack {
                    IconButton()
                    CircleIconButton()
                    
                    IconButtonWithFullWidth()
                }
                
                TextWithImageButton()
                
                LinkButton()
                
                HStack {
                    CaptionIconButton()
                    
                    ToggleIconButton()
                }
                
                TextWrappedButton()
                
                HStack {
                    DashedBorderButton()
                    
                    DashedIconButton()
                }
                
                RadioButton()
                
                CheckmarkButton()
                CheckmarkButton2()
                
                ModernButton()
                ModernButton2()
                
                ButtonWithCustomEffect()
            }
            .padding()
        }
    }
}

#Preview {
    CustomButtonDemoView()
}

// MARK: FillButton
struct FillButton: View{
    var body: some View {
        Button{
            // action will be here
        } label: {
            Text("Fill Button")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(.black)
                .cornerRadius(15)
        }
    }
}

// MARK: Border Button
struct BorderButton: View{
    var body: some View {
        Button{
            // action will be here
        } label: {
            Text("Border Button")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: 52)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black)
                }
        }
    }
}

// MARK: Icon Button
struct IconButton: View {
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "house.fill")
                .frame(width: 52, height: 52)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(15)
        }
    }
}

struct CircleIconButton: View {
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "house.fill")
                .frame(width: 52, height: 52)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(26)
        }
    }
}

struct IconButtonWithFullWidth: View {
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "house.fill")
                .frame(maxWidth: .infinity, minHeight: 52)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(15)
        }
    }
}

// MARK: Text With Image Button
struct TextWithImageButton: View{
    var body: some View {
        Button{
            // action will be here
        } label: {
            HStack {
                Image(systemName: "house.fill")
                Text("Button With Icon")
            }
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .semibold))
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(.black)
            .cornerRadius(15)
            
        }
    }
}

// MARK: Link Button
struct LinkButton: View{
    var body: some View {
        Button{
            // action will be here
        } label: {
            Text("Fill Button")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: 52)
                .underline(true)
        }
    }
}

// MARK: Caption Button
struct CaptionIconButton: View {
    var body: some View {
        Button {
            
        } label: {
            VStack(spacing: 2) {
                Image(systemName: "house.fill")
                    .frame(width: 52, height: 52)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(15)
                Text("Caption Button")
                    .font(.system(size: 12, weight: .semibold))
                    .frame(width: 80)
            }
        }
    }
}

// MARK: Toggle Button
struct ToggleIconButton: View {
    @State var isActive = false
    var body: some View {
        Image(systemName: "house.fill")
            .frame(width: 52, height: 52)
            .foregroundColor(isActive ? .white : .black)
            .background(isActive ? .black : .clear)
            .cornerRadius(15)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black)
            }
            .onTapGesture {
                withAnimation {
                    isActive.toggle()
                }
            }
    }
}

// MARK: Text Wrapped Button
struct TextWrappedButton: View{
    var body: some View {
        Button{
            // action will be here
        } label: {
            Text("Text Wrapped Button")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background(.black)
                .cornerRadius(15)
        }
    }
}

// MARK: Dashed Border Button
struct DashedBorderButton: View{
    var body: some View {
        Button{
            // action will be here
        } label: {
            Text("Dashed Border Button")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: 52)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [10]))
                    
                }
        }
    }
}

struct DashedIconButton: View {
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "house.fill")
                .frame(width: 52, height: 52)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [8]))
                    
                }
        }
    }
}

// MARK: Radio Button
struct RadioButton: View {
    @State var isActive = false
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.black.opacity(isActive ? 1 : 0))
                .frame(width: 14, height: 14)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 2)
                        .frame(width: 20, height: 20)
                }
            
            Text("Radio Button ")
        }
        .onTapGesture {
            withAnimation {
                isActive.toggle()
            }
        }
    }
}

// MARK: Check Mark Button
struct CheckmarkButton: View {
    @State var isActive = false
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isActive ? "checkmark.square.fill" : "")
                .resizable()
                .frame(width: 18, height: 18)
                .cornerRadius(2)
                .overlay {
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(.black)
                        .frame(width: 18, height: 18)
                }
            
            Text("Checkmark Button ")
        }
        .onTapGesture {
            withAnimation {
                isActive.toggle()
            }
        }
    }
}

struct CheckmarkButton2: View {
    @State var isActive = false
    var body: some View {
        HStack(spacing: 12) {
            Text("Full Width Checkmark")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isActive ? .white : .black)
            
            Spacer()
            
            Image(systemName: isActive ? "checkmark.circle.fill" : "")
                .resizable()
                .foregroundColor(isActive ? .white : .black)
                .frame(width: 24, height: 24)
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(isActive ? .white : .black)
                }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(isActive ? .black : .white)
        .cornerRadius(15)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.black)
        }
        .onTapGesture {
            withAnimation {
                isActive.toggle()
            }
        }
    }
}

// MARK: Modern Button
struct ModernButton: View {
    var body: some View {
        Button {
            
        } label: {
            ZStack(alignment: .leading) {
                Text("Modern Button")
                    .font(.system(size: 16, weight: .semibold))
                    .padding()
                    .padding(.leading, 52)
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black)
                    }
                
                Image(systemName: "house.fill")
                    .frame(width: 52, height: 52)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(26)
                    .offset(x: -1)
            }
        }
    }
}
struct ModernButton2: View {
    var body: some View {
        Button {
            
        } label: {
            ZStack(alignment: .leading) {
                Text("Modern Button 2")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(12)
                    .padding(.leading, 30)
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.black)
                    }
                
                Image(systemName: "house.fill")
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(35)
                    .offset(x: -40)
            }
        }
    }
}

// MARK: Button With Custom Pressed Style
struct ButtonPressedEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .secondary : .primary)
            .background(configuration.isPressed ? .secondary : .primary)
            .animation(.easeInOut, value: configuration.isPressed)
            .cornerRadius(15)
    }
}
struct ButtonWithCustomEffect: View{
    var body: some View {
        Button{
            // action will be here
        } label: {
            Text("Custom Pressed Effect")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, minHeight: 52)
        }
        .buttonStyle(ButtonPressedEffect())
    }
}
