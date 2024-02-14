//
//  InteractivePopGesture.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 11/02/2024.
//

import SwiftUI

struct InteractivePopGestureDemoView: View {
    
    @State private var isEnabled: Bool = false
    
    var body: some View {
        FullSwipeNavigationStack {
            List {
                Section("Sample Header") {
                    NavigationLink("Full Swipe View") {
                        List {
                            Toggle("Enable Full Swipe Pop", isOn: $isEnabled)
                                .enableFullSwipePop(isEnabled)
                        }
                        .navigationTitle("Full Swipe Pop")
                    }
                    
                    NavigationLink("Leading Swipe View") {
                        Text("")
                            .navigationTitle("Leading Swipe View")
                    }
                }
            }
            .navigationTitle("Full Swipe Pop")
        }
    }
}

struct FullSwipeNavigationStack<Content: View>: View {
    @ViewBuilder var content: Content
    
    @State private var customGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.name = UUID().uuidString
        gesture.isEnabled = false
        return gesture
    }()
    
    var body: some View {
        NavigationStack {
            content
                .background {
                    AttachGestureView(gesture: $customGesture)
                }
        }
        .environment(\.popGestureID, customGesture.name)
        .onReceive(NotificationCenter.default.publisher(for: .init(customGesture.name ?? "")), perform: { info in
            if let userInfo = info.userInfo, let status = userInfo["status"] as? Bool {
                customGesture.isEnabled = status
            }
        })
    }
}

fileprivate struct PopNotificationID: EnvironmentKey {
    static var defaultValue: String?
}

fileprivate extension EnvironmentValues {
    var popGestureID: String? {
        get {
            self[PopNotificationID.self]
        }
        
        set {
            self[PopNotificationID.self] = newValue
        }
    }
}

fileprivate extension View {
    @ViewBuilder
    func enableFullSwipePop(_ isEnabled: Bool) -> some View {
        self
            .modifier(FullSwipeModifier(isEnabled: isEnabled))
    }
}

fileprivate struct FullSwipeModifier: ViewModifier {
    var isEnabled: Bool
    @Environment(\.popGestureID) private var gestureID
    func body(content: Content) -> some View {
        content
            .onChange(of: isEnabled, initial: true) { oldValue, newValue in
                guard let gestureID = gestureID else { return }
                NotificationCenter.default.post(name: .init(gestureID), object: nil, userInfo: ["status": newValue])
            }
            .onDisappear(perform: {
                guard let gestureID = gestureID else { return }
                NotificationCenter.default.post(name: .init(gestureID), object: nil, userInfo: ["status": false])
            })
    }
}

fileprivate struct AttachGestureView: UIViewRepresentable {
    @Binding var gesture: UIPanGestureRecognizer
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            /// Find parent controller
            if let parentVC = uiView.parentVC {
                if let navigationController = parentVC.navigationController {
                    if let _ = navigationController.view.gestureRecognizers?.first(where: { $0.name == gesture.name }) {
                        
                    } else {
                        navigationController.addFullSwipeGesture(gesture)
                    }
                }
            }
        }
    }
}

fileprivate extension UINavigationController {
    func addFullSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureSelector = interactivePopGestureRecognizer?.value(forKey: "targets") else { return }
        
        gesture.setValue(gestureSelector, forKey: "targets")
        view.addGestureRecognizer(gesture)
    }
}

fileprivate extension UIView {
    var parentVC: UIViewController? {
        sequence(first: self) { $0.next }
            .first(where: { ($0 is UIViewController) }) as? UIViewController
    }
}


#Preview {
    InteractivePopGestureDemoView()
}
