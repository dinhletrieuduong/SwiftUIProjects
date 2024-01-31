//
//  CustomToastView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 23/01/2024.
//

import SwiftUI

struct CustomToastView: View {
    var body: some View {
        CustomToastRootView {
            VStack {
                Button("Present Toast") {
                    Toast.shared.present(title: "AirPods Pro", symbol: "airpodspro", tint: .red, isUserInteractionEnabled: true, timing: .long)
                }
            }
            .padding()
        }
    }
}
/// RootView for creating overlay window
struct CustomToastRootView<Content: View>: View {
    @ViewBuilder var content: Content
    
    /// View Properties
    @State private var overlayWindow: UIWindow?
    var body: some View {
        content
            .onAppear(perform: {
                if let windowScreen = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
                    let window = PassthroughWindow(windowScene: windowScreen)
                    window.backgroundColor = .clear
                    /// View Controller
                    let rootController = UIHostingController(rootView: ToastGroup())
                    rootController.view.frame = windowScreen.keyWindow?.frame ?? .zero
                    rootController.view.backgroundColor = .clear
                    window.rootViewController = rootController
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = 1009
                    overlayWindow = window
                }
            })
    }
    
}

#Preview {
    CustomToastView()
}


fileprivate class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        
        
        return rootViewController?.view == view ? nil : view
    }
}

@Observable
class Toast {
    static let shared = Toast()
    fileprivate var toasts: [ToastItem] = []
    
    private init() { }
    
    func present(title: String, symbol: String?, tint: Color = .primary, isUserInteractionEnabled: Bool = false, timing: ToastTime = .medium) {
        withAnimation(.snappy) {
            toasts.append(.init(title: title, symbol: symbol, tint: tint, isUserInteractionEnabled: isUserInteractionEnabled, timing: timing))
        }
        
    }
}

struct ToastItem: Identifiable {
    let id: UUID = .init()
    /// Custom properties
    var title: String
    var symbol: String?
    var tint: Color
    var isUserInteractionEnabled: Bool
    /// Timing
    var timing: ToastTime = .medium
}

enum ToastTime: CGFloat {
    case short = 1.0
    case medium = 2.0
    case long = 3.0
}

fileprivate struct ToastGroup: View {
    var model = Toast.shared
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                ForEach(model.toasts) { toast in
                    ToastView(size: size, item: toast)
                        .scaleEffect(scale(toast))
                        .offset(y: offsetY(toast))
                        .zIndex(Double(model.toasts.firstIndex(where: { $0.id == toast.id }) ?? 0))
                }
            }
            .padding(.bottom, safeArea.top == .zero ? 15 : 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    func offsetY(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        return (totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)
    }
    
    func scale(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        return 1.0 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount - index) * 0.1))
    }
}

fileprivate struct ToastView: View {
    var size: CGSize
    var item: ToastItem
    /// View properties
    @State private var delayTask: DispatchWorkItem?
    
    var body: some View {
        HStack(spacing: 0) {
            if let symbol = item.symbol {
                Image(systemName: symbol)
                    .font(.title3)
                    .padding(.trailing, 10)
            }
            
            Text(item.title)
                .lineLimit(1)
        }
        .foregroundStyle(item.tint)
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(
            .background
                .shadow(.drop(color: .primary.opacity(0.2), radius: 5, x: 5, y: 5))
                .shadow(.drop(color: .primary.opacity(0.2), radius: 5, x: -5, y: -5)),
            in: .capsule
        )
        .contentShape(.capsule)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded({ value in
                    guard item.isUserInteractionEnabled else { return }
                    let endY = value.translation.height
                    let velocityY = value.velocity.height
                    
                    if endY + velocityY > 100 {
                        /// Removing Toast
                        removeToast()
                    }
                })
        )
        .onAppear {
            guard delayTask == nil else { return }
            delayTask = .init(block: {
                removeToast()
            })
            
            if let delayTask = delayTask {
                DispatchQueue.main.asyncAfter(deadline: .now() + item.timing.rawValue, execute: delayTask)
            }
        }
        /// Limiting Size
        .frame(maxWidth: size.width * 0.7)
        .transition(.offset(y: 150))
    }
    
    func removeToast() {
        if let delayTask {
            delayTask.cancel()
        }
        withAnimation(.snappy) {
            Toast.shared.toasts.removeAll(where: { $0.id == item.id })
        }
    }
}
