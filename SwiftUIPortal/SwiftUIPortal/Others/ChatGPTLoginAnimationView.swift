//
//  ChatGPTLoginAnimationView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 07/02/2024.
//

import SwiftUI

struct ChatGPTLoginAnimationView: View {
    @State private var infos: [ChatGPTLoginAnimationInfo] = simpleInfos
    @State private var activeInfo: ChatGPTLoginAnimationInfo?
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            VStack(spacing: 1) {
                if let activeInfo {
                    Rectangle()
                        .fill(activeInfo.bgColor)
                        .padding(.bottom, -30)
                        .overlay {
                            Circle()
                                .fill(activeInfo.circleColor)
                                .frame(width: 38, height: 38)
                                .background(alignment: .leading) {
                                    Capsule()
                                        .fill(activeInfo.bgColor)
                                        .frame(width: size.width)
                                }
                                .background(alignment: .leading) {
                                    Text(activeInfo.text)
                                        .font(.largeTitle)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(activeInfo.textColor)
                                        .frame(width: textSize(activeInfo.text))
                                        .offset(x: activeInfo.textOffset)
                                }
                                .offset(x: -activeInfo.circleOffset)
                        }
                }
                
                VStack(spacing: 10) {
                    Button(action: {}, label: {
                        Label("Continue with Apple", systemImage: "applelogo")
                            .foregroundStyle(.black)
                            .fillButton(.gray)
                    })
                    .padding()
                    
                    Button(action: {}, label: {
                        Label("Continue with Phone", systemImage: "phone.fill")
                            .foregroundStyle(.white)
                            .fillButton(.gray)
                    })
                    .padding()
                    
                    Button(action: {}, label: {
                        Label("Continue with Email", systemImage: "envelope.fill")
                            .foregroundStyle(.white)
                            .fillButton(.gray)
                            
                    })
                    .padding()
                    
                    
                    Button(action: {}, label: {
                        Text("Login")
                            .foregroundStyle(.white)
                            .fillButton(.black)
                            .shadow(color: .white, radius: 1)
                    })
                    .padding()
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .padding(.bottom, safeArea.bottom)
                .padding(.top, 10)
                .background(.black, in: .rect(topLeadingRadius: 25, topTrailingRadius: 25))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 8)
            }
            .ignoresSafeArea()
            .task {
                if activeInfo == nil {
                    activeInfo = infos.first
                    let nanoSeconds = UInt64(1_000_000_000 * 0.25)
                    try? await Task.sleep(nanoseconds: nanoSeconds)
                    animate(0)
                }
            }
        }
        
    }
    
    private func animate(_ index: Int, _ loop: Bool = true) {
        if infos.indices.contains(index + 1) {
            activeInfo?.text = infos[index].text
            activeInfo?.textColor = infos[index].textColor
            withAnimation(.snappy(duration: 1), completionCriteria: .removed) {
                activeInfo?.textOffset = -(textSize(infos[index].text) + 20)
                activeInfo?.circleOffset = -(textSize(infos[index].text) + 20)/2
            } completion: {
                withAnimation(.snappy(duration: 0.8), completionCriteria: .logicallyComplete) {
                    activeInfo?.textOffset = 0
                    activeInfo?.circleOffset = 0
                    activeInfo?.circleColor = infos[index + 1].circleColor
                    activeInfo?.bgColor = infos[index + 1].bgColor
                } completion: {
                    animate(index + 1)
                }
            }
        } else {
            if loop {
                animate(0, loop)
            }
        }
    }
}

struct ChatGPTLoginAnimationInfo: Identifiable {
    var id: UUID = .init()
    var text: String
    var textColor: Color
    var circleColor: Color
    var bgColor: Color
    var circleOffset: CGFloat = 0
    var textOffset: CGFloat = 0
}

var color1 = Color.red
var color2 = Color.gray
var color3 = Color.green
var color4 = Color.purple
var color5 = Color.blue

var simpleInfos: [ChatGPTLoginAnimationInfo] = [
    .init(text: "Chat GPT", textColor: color5, circleColor: color5, bgColor: color1),
    .init(text: "Let's Create", textColor: color1, circleColor: color1, bgColor: color2),
    .init(text: "Let's Explore", textColor: color2, circleColor: color2, bgColor: color3),
    .init(text: "Let's Invent", textColor: color3, circleColor: color3, bgColor: color4),
    .init(text: "Chat GPT", textColor: color4, circleColor: color4, bgColor: color5),
]

func textSize(_ text: String) -> CGFloat {
    return NSString(string: text).size(withAttributes: [
        .font: UIFont.preferredFont(forTextStyle: .largeTitle)
    ]).width
}

extension View {
    func fillButton(_ color: Color) -> some View {
        self
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 15)
            .background(color, in: .rect(cornerRadius: 15))
    }
}

#Preview {
    ChatGPTLoginAnimationView()
}
