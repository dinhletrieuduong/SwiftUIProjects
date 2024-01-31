//
//  ParallaxCardView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 21/01/2024.
//

import SwiftUI

struct ParallaxCardView: View {
    
    var screenSize: CGSize = {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        return window.screen.bounds.size
    }()
    
    // MARK: Gesture Properties
    @State private var offset: CGSize = .zero
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            let imageSize = size.width * 0.7
            
            VStack {
                Image("nike_shoe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize)
                    .zIndex(1)
                    .offset(x: -20)
                    .offset(x: offset2Angle().degrees * 5, y: offset2Angle(true).degrees * 5)
                
                Text("NIKE AIR")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .padding(.top, -120)
                    .padding(.bottom, 50)
                    .zIndex(0)
                
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("NIKE")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .fontWidth(.compressed)
                    
                    HStack {
                        BlendedText("AIR JORDAN 1 MID SE")
                        
                        Spacer(minLength: 0)
                        
                        BlendedText("$128")
                    }
                    
                    HStack {
                        BlendedText("YOUR NEXT SHOES")
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("BUY")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.black)
                                        .brightness(-0.1)
                                }
                        }
                    }
                    .padding(.top, 14)
                    
                    /// Nike logo
                    Image("nike_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                    
                    
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .foregroundStyle(.white)
            .padding(.top, 65)
            .padding(.horizontal, 15)
            .frame(width: imageSize)
            .background {
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(Color("red"))
                    
                    Circle()
                        .fill(.black.opacity(0.2))
                        .frame(width: imageSize, height: imageSize)
                        .scaleEffect(1.2, anchor: .leading)
                        .offset(x: imageSize * 0.3, y: -imageSize * 0.1)
                }
                .clipShape(.rect(cornerRadius: 25, style: .continuous))
            }
            .rotation3DEffect(offset2Angle(true), axis: (x: -1, y: 0, z: 0))
            .rotation3DEffect(offset2Angle(), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(0.9)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.3, blendDuration: 0.32)) {
                            offset = .zero
                        }
                    }
            )
        })
    }
    
    /// Convert Offset into X, Y angles
    private func offset2Angle(_ isVertical: Bool = false) -> Angle {
        let progress = (isVertical ? offset.height : offset.width) / (isVertical ? screenSize.height : screenSize.width)

        return .init(degrees: progress * 10)
    }
    
    @ViewBuilder
    func BlendedText(_ text: String) -> some View {
        
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .fontWidth(.condensed)
//            .blendMode(.difference)
        
    }
    
}


#Preview {
    ParallaxCardView()
}
