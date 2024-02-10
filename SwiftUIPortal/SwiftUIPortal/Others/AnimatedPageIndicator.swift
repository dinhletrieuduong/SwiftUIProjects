//
//  AnimatedPageIndicator.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 27/01/2024.
//

import SwiftUI

// MARK: AnimatedPageIndicator
struct AnimatedPageIndicator: View {
    /// View properties
    @State private var colors: [Color] = [.red, .blue, .green, .yellow]
    @State private var opacityEffect: Bool = false
    @State private var clipEdges: Bool = false
    
    var body: some View {
        VStack {
            /// Paging View
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 25)
                            .fill(color.gradient)
                            .padding(.horizontal, 5)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
                .overlay(alignment: .bottom) {
                    PagingIndicator(opacityEffect: opacityEffect, clipEdges: clipEdges, activeTint: .white, inActiveTint: .black.opacity(0.25))
                }
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .frame(height: 220)
            //            .padding(.top, 15)
            .safeAreaPadding(.vertical, 15)
            .safeAreaPadding(.horizontal, 25)
            
            List {
                Section("Options") {
                    Toggle("Opacity Effect", isOn: $opacityEffect)
                    Toggle("Clip Edges", isOn: $clipEdges)
                    
                    Button("Add Item") {
                        colors.append(.purple)
                    }
                }
            }
            .clipShape(.rect(cornerRadius: 15))
            .padding(15)
            
        }
        .navigationTitle("Custom Indicator")
    }
}

// MARK: PagingIndicator
struct PagingIndicator: View {
    /// Customization Properties
    var opacityEffect: Bool = false
    var clipEdges: Bool = false
    var activeTint: Color = .primary
    var inActiveTint: Color = .primary.opacity(0.15)
    
    var body: some View {
        GeometryReader { proxy in
            /// Entire View Size for Calculating Pages
            let width = proxy.size.width
            
            /// ScrollView Bounds
            if let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width,
               scrollViewWidth > 0 {
                let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
                let totalPages = Int(width / scrollViewWidth)
                /// Progress
                let freeProgress = -minX / scrollViewWidth
                let clippedProgress = min(max(freeProgress, 0.0), CGFloat(totalPages - 1))
                let progress = clipEdges ? clippedProgress : freeProgress
                /// Indexes
                let activeIndex = Int(progress)
                let nextIndex = Int(progress.rounded(.awayFromZero))
                let indicatorProgress = progress - CGFloat(activeIndex)
                /// Indicator Width's (Current & Upcoming)
                let currentPageWidth = 18 - (indicatorProgress * 18)
                let nextPageWidth = indicatorProgress * 18
                
                HStack(spacing: 10) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Capsule()
                            .fill(inActiveTint)
                            .frame(width: 8 + (activeIndex == index ? currentPageWidth : (nextIndex == index ? nextPageWidth : 0)), height: 8)
                            .overlay {
                                ZStack {
                                    Capsule()
                                        .fill(inActiveTint)
                                    
                                    Capsule()
                                        .fill(activeTint)
                                        .opacity(opacityEffect ? (activeIndex == index ? 1-indicatorProgress : (nextIndex == index ? indicatorProgress : 0)) : 1)
                                }
                            }
                    }
                }
                .frame(width: scrollViewWidth)
                .offset(x: -minX)
            }
        }
        .frame(height: 30)
    }
}

private struct Item: Identifiable {
    private(set) var id: UUID = .init()
    var color: Color
    var title: String
    var subTitle: String
}

struct CustomPagingSliderDemoView: View {
    @State private var items: [Item] = [
        .init(color: .red, title: "World Clock", subTitle: "View the time in multiple cities around the world."),
        .init(color: .blue, title: "City Digital", subTitle: "Add a clock for a city to check the time at that location"),
        .init(color: .green, title: "City Analouge", subTitle: "Add a clock for a city to check the time at that location"),
        .init(color: .yellow, title: "Next Alarm", subTitle: "Display upcoming alarm."),
    ]
    
    
    @State private var showsPagingControl: Bool = true
    @State private var disablePagingInteraction: Bool = false
    @State private var pagingSpacing: CGFloat = 20
    @State private var titleScrollSpeed: CGFloat = 0.6
    @State private var stretchContent: Bool = false
    
    var body: some View {
        
        ScrollView {
            VStack {
                AnimatedPageIndicator()
                    .frame(height: 500)
                
                CustomPagingSlider(showsPagingControl: showsPagingControl, pagingControlSpacing: pagingSpacing, disablePagingIndicator: disablePagingInteraction, titleScrollSpeed: titleScrollSpeed, data: $items) { $item in
                    RoundedRectangle(cornerRadius: 25)
                        .fill(item.color.gradient)
                        .frame(width: stretchContent ? nil : 150, height: stretchContent ? 220 : 120)
                    
                } titleContent: { item in
                    VStack(spacing: 5) {
                        Text(item.title.wrappedValue)
                            .font(.largeTitle.bold())
                        
                        Text(item.subTitle.wrappedValue)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .frame(height: 45)
                    }
                    .padding(.bottom, 35)
                    
                }
                
                List {
                    Toggle("Show Paging Control", isOn: $showsPagingControl)
                    Toggle("Disable Page Interaction", isOn: $disablePagingInteraction)
                    Toggle("Stretch Content", isOn: $stretchContent)
                    
                    Section("Title Scroll Speed") {
                        Slider(value: $titleScrollSpeed, in: 0...40)
                    }
                    Section("Paging Spacing") {
                        Slider(value: $pagingSpacing, in: 20...40)
                    }
                }
                .clipShape(.rect(cornerRadius: 15))
                .padding(15)
                .frame(height: 450)
            }
        }
    }
}


struct CustomPagingSlider<Content: View, TitleContent: View, Item: RandomAccessCollection>: View where Item: MutableCollection, Item.Element: Identifiable {
    
    var showsPagingControl: Bool = true
    var showsIndicator: ScrollIndicatorVisibility = .hidden
    var pagingControlSpacing: CGFloat = 20
    var disablePagingIndicator: Bool = false
    
    var titleScrollSpeed: CGFloat = 0.6
    var spacing: CGFloat = 10
    
    @Binding var data: Item
    
    @ViewBuilder var content: (Binding<Item.Element>) -> Content
    @ViewBuilder var titleContent: (Binding<Item.Element>) -> TitleContent
    
    @State private var activeID: UUID?
    
    var body: some View {
        VStack(spacing: pagingControlSpacing) {
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    ForEach($data) { item in
                        VStack(spacing: 0) {
                            titleContent(item)
                                .frame(maxWidth: .infinity)
                                .visualEffect { content, geometryProxy in
                                    content
                                        .offset(x: scrollOffset(geometryProxy))
                                }
                            
                            content(item)
                        }
                        .containerRelativeFrame(.horizontal)
                    }
                }
                /// Add paging
                .scrollTargetLayout()
            }
            .scrollIndicators(showsIndicator)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeID)
            
            if showsPagingControl {
                PageControl(totalPages: data.count, currentPage: activePage) { value in
                    if let index = value as? Item.Index, data.indices.contains(index) {
                        if let id = data[index].id as? UUID {
                            withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                                activeID = id
                            }
                        }
                    }
                }
                .disabled(disablePagingIndicator)
            }
        }
        .safeAreaPadding([.horizontal, .top], 35)
    }
    
    var activePage: Int {
        if let index = data.firstIndex(where: { $0.id as? UUID == activeID }) as? Int {
            return index
        }
        return 0
    }
    
    private func scrollOffset(_ proxy: GeometryProxy) -> CGFloat{
        let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
        
        return -minX * min(titleScrollSpeed, 1)
    }
    
}


#Preview {
    NavigationStack {
        CustomPagingSliderDemoView()
    }
    
}
