//
//  BoomerangCardsView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 12/02/2024.
//

import SwiftUI

import SwiftAndTipsMacros
import DataGenerator

struct BoomerangCardsDemoView: View {
    @State private var cards: [CardModel] = CardModel.sample
    
    @State var isBlurEnabled: Bool = false
    @State var isRotationEnabled: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                Toggle("Enable Blur", isOn: $isBlurEnabled)
                Toggle("Enable Rotation", isOn: $isRotationEnabled)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            BoomerangCardsView(cards: $cards, isRotationEnabled: isRotationEnabled, isBlurEnabled: isBlurEnabled)
                .frame(height: 220)
                .padding(.horizontal, 15)
        }
        .padding(15)
        .background {
            Color("ThemeBG")
                .ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: {
            setupCards()
        })
    }
    
    func setupCards() {
        cards = CardModel.sample
        
        for index in cards.indices {
            cards[index].scale = 1
            cards[index].zIndex = 0
        }
        
        if var first = cards.first {
            first.id = UUID()
            cards.append(first)
        }
    }
}

struct BoomerangCardsView: View {
    @Binding fileprivate var cards: [CardModel]
    
    var isRotationEnabled: Bool = false
    var isBlurEnabled: Bool = false
    
    @State var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach(cards.reversed(), id:\.id) { card in
                    CardView(card, size: size)
                        .offset(y: currentIndex == indexOf(card: card) ? offset : 0)
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: offset == .zero)
            .frame(width: size.width, height: size.height)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged(onChanged(value:))
                    .onEnded(onEnded(value:))
            )
        }
    }
    
    func onChanged(value: DragGesture.Value) {
        offset = currentIndex == cards.count - 1 ? 0 : value.translation.height
    }
    
    func onEnded(value: DragGesture.Value) {
        var translation = value.translation.height
        translation = translation < 0 ? -translation : 0
        translation = currentIndex == cards.count - 1 ? 0 : translation
        
        if translation > 110 {
            /// Boomerang effect
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                cards[currentIndex].isRotated = true
                /// Give slightly bigger than card height
                cards[currentIndex].extraOffset = -350
                cards[currentIndex].scale = 0.7
            }
            
            /// Delay for a while to reset gesture offset and extra offset
            /// Push card into back using zIndex
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                    cards[currentIndex].zIndex = -100
                    for index in cards.indices {
                        cards[index].extraOffset = 0
                    }
                    
                    if currentIndex != cards.count - 1 {
                        currentIndex += 1
                    }
                    offset = .zero
                }
            }
            
            /// Reset rotation and scaling and set proper zIndex value when animation is completed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for index in cards.indices {
                    if index == currentIndex {
                        if cards.indices.contains(currentIndex - 1) {
                            cards[currentIndex - 1].zIndex = ZIndex(card: cards[currentIndex - 1])
                        }
                    } else {
                        cards[index].isRotated = false
                        withAnimation(.linear) {
                            cards[index].scale = 1
                        }
                    }
                }
                
                if currentIndex == cards.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        for index in cards.indices {
                            cards[index].zIndex = 0
                        }
                        currentIndex = 0
                    }
                }
            }
        } else {
            
            offset = .zero
            
        }
    }
    
    @ViewBuilder
    fileprivate func CardView(_ card: CardModel, size: CGSize) -> some View {
        let index = indexOf(card: card)
        AsyncImage(url: card.imageURL)
//        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: size.width, height: size.height)
        .blur(radius: card.isRotated && isBlurEnabled ? 6.5 : 0)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//        .background {
//            Color(hex: "\(card.color)")
//        }
        .scaleEffect(card.scale, anchor: card.isRotated ? .center : .top)
        .rotation3DEffect(.init(degrees: isRotationEnabled && card.isRotated ? 360 : 0), axis: (x: 0, y: 0, z: 1))
        .offset(y: -offsetFor(index: index))
        .offset(y: card.extraOffset)
        .scaleEffect(scaleFor(index: index), anchor: .top)
        .zIndex(card.zIndex)
    }
    
    func scaleFor(index value: Int) -> Double {
        let index = Double(value - currentIndex)
        if index >= 0 {
            if index > 3 {
                return 0.8
            }
            /// For each card 0.06 scale will be reduced
            return 1 - (index / 15)
        } else {
            if abs(index) > 3 {
                return 0.8
            }
            /// For each card 0.06 scale will be reduced
            return 1 + (index / 15)
        }
    }
    
    
    func offsetFor(index value: Int) -> Double {
        let index = Double(value - currentIndex)
        if index >= 0 {
            if index > 3 {
                return 30
            }
            
            return (index * 10)
        } else {
            if abs(index) > 3 {
                return 30
            }
            
            return (-index * 10)
        }
    }
    
    fileprivate func indexOf(card: CardModel) -> Int {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            return index
        }
        return 0
    }
    
    fileprivate func ZIndex(card: CardModel) -> Double {
        let index = indexOf(card: card)
        let totalCount = cards.count
        return currentIndex > index ? Double(index - totalCount) : cards[index].zIndex
    }
}

@SampleBuilder(numberOfItems: 6, dataGeneratorType: .random)
fileprivate struct CardModel {
    var id: UUID = .init()
    @SampleBuilderItem(category: .image(width: 500, height: 220))
    var imageURL: URL
    var isRotated: Bool = false
    var extraOffset: CGFloat = 0
    
    var scale: CGFloat = 1
    var zIndex: Double = 0
    var color: UInt32
}

#Preview {
    BoomerangCardsDemoView()
}
