//
//  IncomingCall.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 21/02/2024.
//

import SwiftUI

struct IncomingCall: View {
    
    @State private var isCalling = false
    let easeGently = Animation.easeOut(duration: 1).repeatForever(autoreverses: true)
    let pulsingColor = #colorLiteral(red: 0, green: 0.3725490196, blue: 1, alpha: 1)
    
    var body: some View {
        NavigationStack {
            ZStack {
                /*Image("blurLayer")
                 .resizable()
                 .ignoresSafeArea()*/
                
                VStack {
                    Spacer()
                    
                    VStack {
                        ZStack {
                            // Outer
                            Circle()
                                .fill(Color(pulsingColor).gradient)
                                .frame(width: 172, height: 172)
                            //.blendMode(.lighten)
                                .opacity(0.1)
                                .scaleEffect(isCalling ? 0.8 : 1.2)
                                .zIndex(isCalling ? 0 : 1)
                                .animation(easeGently.delay(0.2), value: isCalling)
                            
                            // Middle
                            Circle()
                                .fill(Color(pulsingColor).gradient)
                                .frame(width: 172, height: 172)
                            //.blendMode(.screen)
                                .opacity(0.2)
                                .scaleEffect(isCalling ? 0.7 : 1.1)
                                .zIndex(isCalling ? 0 : 3)
                                .animation(easeGently.delay(0.4), value: isCalling)
                            
                            // Inner
                            Circle()
                                .fill(Color(pulsingColor).gradient)
                                .frame(width: 172, height: 172)
                            //.blendMode(.colorDodge)
                                .opacity(0.3)
                                .zIndex(isCalling ? 0 : 3)
                                .scaleEffect(isCalling ? 0.5 : 1.2)
                                .animation(easeGently.delay(0.6), value: isCalling)
                            
                            
                            Image(.animoji4)
                                .resizable()
                                .frame(width: 172, height: 172)
                                .hueRotation(Angle(degrees: isCalling ? 0 : .random(in: 0...120)))
                                .clipShape(Circle())
                                .opacity(isCalling ? 1 : 0.1)
                                .scaleEffect(isCalling ? 1 : 0.5)
                                .animation(easeGently, value: isCalling)
                        }
                        .onAppear {
                            withAnimation {
                                isCalling.toggle()
                            }
                        }
                        
                        Text("Awo Yaa")
                            .font(.title)
                        
                        HStack(alignment: .bottom, spacing: 0) {
                            Text("Calling")
                            Image(systemName: "ellipsis")
                                .symbolEffect(
                                    .variableColor.iterative.reversing
                                )
                                .foregroundStyle(
                                    EllipticalGradient(colors:[Color(pulsingColor), .green], center: .center, startRadiusFraction: 0.0, endRadiusFraction: 0.5)
                                )
                                .hueRotation(.degrees(isCalling ? 0 : 300))
                                .animation(easeGently.delay(0.6), value: isCalling)
                        }
                        .font(.title3)
                        .bold()
                        
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "phone.down.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 80))
                        
                        Spacer()
                        
                        Image(systemName: "phone.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 80))
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 48, bottom: 16, trailing: 48))
                    
                }
                .toolbar {
                    // Leading navigation items
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button{
                            print("Pressed back arrow button")
                        } label: {
                            Image(systemName: "chevron.backward")
                        }
                        
                        Button("Messages") {
                            print("Pressed messages button")
                        }
                    }
                    
                    // Trailing navigation item
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button{
                            print("Pressed person button")
                        } label: {
                            Image(systemName: "person.3.fill")
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    IncomingCall()
        .preferredColorScheme(.dark)
}
