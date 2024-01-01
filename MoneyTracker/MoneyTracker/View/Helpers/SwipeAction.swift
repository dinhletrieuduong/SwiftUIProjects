//
//  SwipeAction.swift
//  MoneyTracker
//
//  Created by Dinh Le Trieu Duong on 31/12/2023.
//

import SwiftUI

struct SwipeAction<Content: View>: View {
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    
    @ViewBuilder var content: Content
    @ActionBuilder var actions: [ActionModel]
    
    /// View properties
    @Environment(\.colorScheme) private var scheme
    
    /// View unique id
    let viewID = "CONTENT_VIEW"
    @State private var isEnabled: Bool = true
    @State private var scrollOffset: CGFloat = .zero
    
    var body: some View {
        ScrollViewReader(content: { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0, content: {
                    content
                        .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
                        /// To take full available space
                        .containerRelativeFrame(.horizontal)
                        .background(scheme == .dark ? .black : .white)
                        .background {
                            if let firstAction = filteredActions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                
                                Color.clear
                                    .preference(key: OffsetKey.self, value: minX)
                                    .onPreferenceChange(OffsetKey.self) {
                                        scrollOffset = $0
                                    }
                            }
                        }
                    
                    ActionButtons {
                        withAnimation(.snappy) {
                            proxy.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                })
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = filteredActions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                        .opacity(scrollOffset == .zero ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
        })
        .allowsHitTesting(isEnabled)
        .transition(CustomTransition())
    }
    
    /// Action Buttons
    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
        /// Each button will have 100 width
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(filteredActions.count) * 100)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0, content: {
                    ForEach(filteredActions) { button in
                        Button(action: {
                            Task {
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.25)) // can ignore this sleep
                                button.action()
                                try? await Task.sleep(for: .seconds(0.1))
                                isEnabled = true
                            }
                        }, label: {
                            Image(systemName: button.icon)
                                .font(button.iconFont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        })
                        .buttonStyle(.plain)
                        .background(button.tint)
                        .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
                    }
                })
            }
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        
        return (minX > 0 ? -minX : 0)
    }
    
    var filteredActions: [ActionModel] {
        return actions.filter({ $0.isEnabled })
    }
}

/// Offset Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

/// Custom Transition
struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader {
                    let size = $0.size
                    
                    Rectangle()
                        .offset(y: phase == .identity ? 0 : -size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}

/// Swipe Direction
enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
        }
    }
}

/// Action Model
struct ActionModel: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> ()
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: ActionModel...) -> [ActionModel] {
        return components
    }
}
