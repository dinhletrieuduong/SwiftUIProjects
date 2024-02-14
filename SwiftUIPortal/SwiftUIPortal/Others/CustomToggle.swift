//
//  CustomToggle.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 12/02/2024.
//

import SwiftUI

struct CustomToggle: View {
    @State private var isOn: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            Toggle(isOn: $isOn, label: {
                
            })
            .toggleStyle(CheckmarkToggleStyle())
            
            
            Toggle(isOn: $isOn, label: {
                    
            })
            .toggleStyle(PowerToggleStyle())
            .frame(width: 100)
            
            Toggle(isOn: $isOn, label: {
                    
            })
            .toggleStyle(ImageToggleStyle(onImageName: "image_care", offImageName: "image_mood"))
            .frame(width: 100)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    CustomToggle()
}

struct CheckmarkToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Rectangle()
                .foregroundColor(configuration.isOn ? .green : .gray)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.black))
                                .frame(width: 8, height: 8, alignment: .center)
                                .foregroundColor(configuration.isOn ? .green : .gray)
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.linear(duration: 0.1))
                    
                )
                .cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
    
}

struct PowerToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? .green : .gray)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            GeometryReader { geo in
                                Path { p in
                                    if !configuration.isOn {
                                        p.addRoundedRect(in: CGRect(x: 10, y: 10, width: 10.5, height: 10.5), cornerSize: CGSize(width: 7.5, height: 7.5), style: .circular, transform: .identity)
                                    } else {
                                        p.move(to: CGPoint(x: 51/4 + 4, y: 10))
                                        p.addLine(to: CGPoint(x: 51/4 + 4, y: 31-10))
                                    }
                                }.stroke(configuration.isOn ? Color.green : Color.gray, lineWidth: 2)
                            }
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.linear(duration: 0.1))
                    
                )
                .cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

struct ImageToggleStyle: ToggleStyle {
    
    var onImageName: String
    var offImageName: String
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(configuration.isOn ? onImageName : offImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 51, height: 31, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                        .animation(Animation.linear(duration: 0.1))
                ).cornerRadius(20)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
