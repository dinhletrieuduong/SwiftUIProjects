//
//  SpotlightView.swift
//  ExpenseTracker
//
//  Created by Dinh Le Trieu Duong on 06/02/2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func addSpotlight(_ id: Int, shape: SpotlightShape = .rectangle, roundedRadius: CGFloat = 0, text: String = "") -> some View {
        self
            .anchorPreference(key: BoundsKey.self, value: .bounds, transform: { anchor in
                [id: BoundsKeyProperties(shape: shape, anchor: anchor, text: text, radius: roundedRadius)]
            })
    }
    
    @ViewBuilder
    func addSpotlightOverlay(show: Binding<Bool>, currentSpot: Binding<Int>) -> some View {
        self
            .overlayPreferenceValue(BoundsKey.self) { values in
                GeometryReader { proxy in
                    if let preference = values.first(where: { item in
                        item.key == currentSpot.wrappedValue
                    }) {
                        let screenSize = proxy.size
                        let anchor = proxy[preference.value.anchor]
                        
                        SpotlightHelperView(screenSize: screenSize, rect: anchor, show: show, currentSpot: currentSpot, properties: preference.value) {
                            if currentSpot.wrappedValue <= values.count {
                                currentSpot.wrappedValue += 1
                            } else {
                                show.wrappedValue = false
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                .animation(.easeInOut, value: show.wrappedValue)
                .animation(.easeInOut, value: currentSpot.wrappedValue)
            }
    }
    
    // MARK: Helper view
    @ViewBuilder
    func SpotlightHelperView(screenSize: CGSize, rect: CGRect, show: Binding<Bool>, currentSpot: Binding<Int>, properties: BoundsKeyProperties, onTap: @escaping () -> Void) -> some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .environment(\.colorScheme, .dark)
            .opacity(show.wrappedValue ? 1 : 0)
            .overlay(alignment: .topLeading) {
                Text(properties.text)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .opacity(0)
                    .overlay {
                        GeometryReader { proxy in
                            let textSize = proxy.size
                            
                            Text(properties.text)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .offset(x: (rect.minX + textSize.width) > (screenSize.width - 15) ? -((rect.minX + textSize.width) - (screenSize.width - 15)) : 0 )
                                .offset(y: (rect.maxY + textSize.height) > (screenSize.height - 50) ? -(textSize.height + (rect.maxY - rect.minY) + 30) : 30)
                        }
                        .offset(x: rect.minX, y: rect.maxY)
                    }
            }
            .mask {
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        let radius = properties.shape == .circle ? (rect.width/2) : (properties.shape == .rounded ? properties.radius : 0)
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .frame(width: rect.width, height: rect.height)
                            .offset(x: rect.minX, y: rect.minY)
                            .blendMode(.destinationOut)
                    }
            }
            .onTapGesture {
                /// Update spotlight spot if available
                onTap()
            }
        
    }
}

enum SpotlightShape {
    case circle
    case rectangle
    case rounded
}

struct BoundsKey: PreferenceKey {
    static var defaultValue: [Int: BoundsKeyProperties] = [:]
    
    static func reduce(value: inout [Int : BoundsKeyProperties], nextValue: () -> [Int : BoundsKeyProperties]) {
        value.merge(nextValue()) { $1 }
    }
}

struct BoundsKeyProperties {
    var shape: SpotlightShape
    var anchor: Anchor<CGRect>
    var text: String = ""
    var radius: CGFloat = 0
}

#Preview(body: {
    ContentView()
})
