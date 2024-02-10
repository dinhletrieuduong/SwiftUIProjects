//
//  InfiniteCarouselView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 14/01/2024.
//

import SwiftUI

struct InfiniteCarouselView: View {
    
    /// View properties
    @State private var currentPage: String = ""
    @State private var listOfPages: [PageModel] = []
    
    /// Infinite carousel properties
    @State private var fakedPages: [PageModel] = [] /// Contains the first and last duplicate pages in front & back to create infinite carousel
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            TabView(selection: $currentPage,
                    content:  {
                ForEach(fakedPages) { page in
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(page.color.gradient)
                        .frame(width: 300, height: size.height)
                        .tag(page.id.uuidString)
                        /// Calculate entire page scroll offset
                        .offsetX(currentPage == page.id.uuidString) { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * CGFloat(fakeIndex(of: page)))
                            
                            /// Convert page offset into progress
                            let pageProgress = pageOffset / size.width
                            /// Infinite Carousel logic
                            if -pageProgress < 1.0 {
                                /// Moving to the last page
                                /// Which is actually the first duplicated page
                                /// Safe check
                                if fakedPages.indices.contains(fakedPages.count - 1) {
                                    /// Immediately go to the last page
                                    currentPage = fakedPages[fakedPages.count - 1].id.uuidString
                                }
                            }
                            if -pageProgress > CGFloat(fakedPages.count - 1) {
                                /// Moving to the first page
                                /// Which is actually the last duplicated page
                                /// Safe check
                                if fakedPages.indices.contains(1) {
                                    /// Immediately go to the first page
                                    currentPage = fakedPages[1].id.uuidString
                                }
                            }
                        }
                }
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .bottom) {
                PageControl(totalPages: listOfPages.count, currentPage: originalIndex(of: currentPage)) { index in
                    print(index)
                    currentPage = listOfPages[index].id.uuidString
                }
                    .offset(y: -15)
            }
        }
        .frame(height: 400)
        /// Create some sample Tab's
        .onAppear {
            guard fakedPages.isEmpty else { return }
            for color in [Color.red, Color.blue, Color.yellow, Color.black, Color.brown] {
                listOfPages.append(.init(color: color))
            }
            
            fakedPages.append(contentsOf: listOfPages)
            
            if var firstPage = listOfPages.first, var lastPage = listOfPages.last {
                currentPage = firstPage.id.uuidString
                
                /// Update ID
                firstPage.id = .init()
                lastPage.id = .init()
                
                fakedPages.append(firstPage)
                fakedPages.insert(lastPage, at: 0)
            }
        }
    }
    
    private func fakeIndex(of: PageModel) -> Int {
        return fakedPages.firstIndex(of: of) ?? 0
    }
    
    private func originalIndex(of id: String) -> Int {
        return listOfPages.firstIndex(where: { $0.id.uuidString == id }) ?? 0
    }
    
}

/// Page control
struct PageControl: UIViewRepresentable {
    /// Page properties
    var totalPages: Int
    var currentPage: Int
    
    var onPageChanged: (Int) -> Void
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = totalPages
        control.currentPage = currentPage
        control.backgroundStyle = .prominent
        control.allowsContinuousInteraction = false
//        control.isUserInteractionEnabled = false
        control.currentPageIndicatorTintColor = UIColor(Color.primary)
        control.pageIndicatorTintColor = UIColor.placeholderText
        
        control.addTarget(context.coordinator, action: #selector(Coordinator.onPageUpdate(control:)), for: .valueChanged)
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.numberOfPages = totalPages
        uiView.currentPage = currentPage
    }
    
    class Coordinator: NSObject {
        var onPageChanged: (Int) -> Void
        init(onPageChanged: @escaping (Int) -> Void) {
            self.onPageChanged = onPageChanged
        }
        
        @objc func onPageUpdate(control: UIPageControl) {
            onPageChanged(control.currentPage)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onPageChanged: onPageChanged)
    }
}

/// Helpers
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

private extension View {
    @ViewBuilder
    func offsetX(_ addObserver: Bool, completion: @escaping (CGRect) -> ()) -> some View {
        self
            .frame(maxWidth: .infinity)
            .overlay {
                if addObserver {
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        
                        Color.clear
                            .preference(key: OffsetKey.self, value: rect)
                            .onPreferenceChange(OffsetKey.self, perform: completion)
                    }
                }
            }
    }
}

/// Models
private struct PageModel: Identifiable, Hashable {
    var id: UUID = .init()
    var color: Color
}

#Preview {
    InfiniteCarouselView()
}
