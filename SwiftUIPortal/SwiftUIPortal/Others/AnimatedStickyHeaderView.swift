//
//  AnimatedStickyHeaderView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 24/01/2024.
//

import SwiftUI


struct HomeAnimatedStickyHeaderView: View {
    
    var size: CGSize
    var safeArea: EdgeInsets
    
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    HeaderView()
                        .zIndex(1000)
                    
                    SampleCardView()
                        .padding(.horizontal)
                }
                .id("SCROLL")
                .background {
                    ScrollDetector { offset in
                        offsetY = -offset
                    } onDraggingEnd: { offset, velocity in
                        /// Reset to initial state, if not completely scrolled
                        let headerHeight = size.height * 0.5 + safeArea.top
                        let minimumHeaderHeight = 65 + safeArea.top
                        
                        let targetEnd = offset + velocity * 45
                        
                        if targetEnd < (headerHeight - minimumHeaderHeight) && targetEnd > 0 {
                            withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.65, blendDuration: 0.65)) {
                                scrollProxy.scrollTo("SCROLL", anchor: .top)
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        let headerHeight = size.height * 0.4 + safeArea.top
        let minimumHeaderHeight = 65 + safeArea.top
        
        /// Converting offset into progress, limit 0 - 1
        let progress = max(min(-offsetY / (headerHeight - minimumHeaderHeight), 1), 0)
        
        GeometryReader { _ in
            ZStack {
                Rectangle()
                    .fill(.black)
                
                VStack(spacing: 5) {
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        let halfScaleHeight = (rect.height * 0.3) * 0.5
                        let midY = rect.midY
                        let bottomPadding: CGFloat = 15
                        let resizedOffsetY = midY - (minimumHeaderHeight - halfScaleHeight - bottomPadding)
                        
                        Image("Intro")
                            .resizable()
                            .clipShape(Circle())
                            .scaleEffect(1 - (progress * 0.7), anchor: .leading)
                        /// Move scaled image to center leading
                            .offset(x: -(rect.minX - 15) * progress, y: -resizedOffsetY * progress)
                    }
                    .frame(width: headerHeight * 0.5, height: headerHeight * 0.5)
                    
                    Text("Piu Piu")
                        .font(.title)
                        .foregroundStyle(.white)
                        .bold()
                        .scaleEffect(1 - (progress * 0.15))
                    /// Move text little bit: 4.5 - 15 (spacing) / 0.3 (image scaling)
                        .offset(y: -4.5 * progress)
                    
                    Text("Relaxing")
                        .foregroundStyle(.white)
                        .scaleEffect(1 - (progress * 0.15))
                    /// Move text little bit: 4.5 - 15 (spacing) / 0.3 (image scaling)
                        .offset(y: -4.5 * progress)
                }
                .padding(.top, safeArea.top)
                .padding(.bottom, 15)
            }
            .frame(height: (headerHeight + offsetY) < minimumHeaderHeight ? minimumHeaderHeight : (headerHeight + offsetY), alignment: .bottom)
            .offset(y: -offsetY)
        }
        .frame(height: headerHeight)
    }
}

/// Extracting UIScroll from SwiftUI ScrollView
struct ScrollDetector: UIViewRepresentable {
    var onScroll: (CGFloat) -> Void
    var onDraggingEnd: (CGFloat, CGFloat) -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView {
                scrollView.delegate = context.coordinator
                context.coordinator.isDelegateAdded = true
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollDetector
        
        init(parent: ScrollDetector) {
            self.parent = parent
        }
        
        /// One time delegate initialization
        var isDelegateAdded: Bool = false
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentOffset.y)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            parent.onDraggingEnd(targetContentOffset.pointee.y, velocity.y)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView.panGestureRecognizer.view)
            
            parent.onDraggingEnd(scrollView.contentOffset.y, velocity.y)
        }
    }
}

@ViewBuilder
func SampleCardView() -> some View {
    VStack(spacing: 10, content: {
        ForEach(1..<25, id: \.self) { index in
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.black.opacity(0.05))
                .frame(height: 80)
                
        }
    })
}
struct ContentHomeAnimatedStickyHeaderView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            HomeAnimatedStickyHeaderView(size: size, safeArea: safeArea)
                .ignoresSafeArea(.all, edges: .top)
            
        }
    }
}

#Preview {
    ContentHomeAnimatedStickyHeaderView()
}
