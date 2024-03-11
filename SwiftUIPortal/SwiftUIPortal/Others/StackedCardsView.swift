//
//  StackedCardsView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 11/03/2024.
//

import SwiftUI

struct StackedCardsView: View {
    
    @State private var isRotationEnabled: Bool = true
    @State private var showIndicator: Bool = false
    
    
    var body: some View {
        VStack {
            GeometryReader {
                let size = $0.size
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(items, id: \.id) { item in
                            CardView(item)
                                .padding(.horizontal, 65)
                                .frame(width: size.width)
                                .visualEffect { content, geometryProxy in
                                    content
                                        .scaleEffect(scale(geometryProxy, scale: 0.1), anchor: .trailing)
                                        .rotationEffect(rotation(geometryProxy, rotation: isRotationEnabled ? 5 : 0))
                                        .offset(x: minX(geometryProxy))
                                        .offset(x: excessMinX(geometryProxy, offset: 10))
                                }
                                .zIndex(items.zIndex(item))
                                
                        }
                    }
                    .padding(.vertical, 15)
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(showIndicator ? .visible : .hidden)
                .scrollIndicatorsFlash(trigger: showIndicator)
            }
            .frame(height: 410)
            .animation(.snappy, value: isRotationEnabled)
            
            VStack(spacing: 10) {
                Toggle("Rotation Enabled", isOn: $isRotationEnabled)
                Toggle("Shows Scroll Indicator", isOn: $showIndicator)
            }
            .padding(15)
            .background(.bar, in: .rect(cornerRadius: 10))
            .padding(15)
        }
        .navigationTitle("Stacked Cards")
    }
    
    @ViewBuilder
    fileprivate func CardView(_ item: CardItem) -> some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(item.color.gradient)
    }
    
    /// Stacked Card Animation
    fileprivate func minX(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return minX < 0 ? 0 : -minX
    }
    
    /// Limit: determines how many cards will be showed from the trailing side
    fileprivate func progress(_ proxy: GeometryProxy, limit: CGFloat = 2) -> CGFloat {
        let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
        guard let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width else { return 0 }
        
        let progress = (maxX / width) - 1.0
        
        let cappedProgress = min(progress, limit)
        
        return cappedProgress
    }
    
    fileprivate func scale(_ proxy: GeometryProxy, scale: CGFloat = 0.1) -> CGFloat {
        let progress = progress(proxy, limit: 2)
        return 1 - progress * scale
    }
    
    func excessMinX(_ proxy: GeometryProxy, offset: CGFloat = 10) -> CGFloat {
        let progress = progress(proxy, limit: 2)
        
        return progress * offset
    }
    
    func rotation(_ proxy: GeometryProxy, rotation: CGFloat = 5) -> Angle {
        let progress = progress(proxy, limit: 2)
        return .init(degrees: progress * rotation)
    }
}


#Preview {
    NavigationStack {
        StackedCardsView()
    }
}


fileprivate struct CardItem: Identifiable {
    var id: UUID = .init()
    var color: Color
}

fileprivate var items: [CardItem] = [
    .init(color: .red),
    .init(color: .blue),
    .init(color: .green),
    .init(color: .yellow),
    .init(color: .pink),
    .init(color: .purple),
    .init(color: .indigo),
]

fileprivate extension [CardItem] {
    func zIndex(_ item: CardItem) -> CGFloat {
        if let index = firstIndex(where: { $0.id == item.id }) {
            return CGFloat(count) - CGFloat(index)
        }
        return 0
    }
}
