//
//  StatusBarUpdateView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 14/01/2024.
//

import SwiftUI

struct StatusBarUpdateView: View {
    var body: some View {
        StatusBarView {
            StatusBarContentView()
        }
    }
}

struct StatusBarView<Content: View>: View {
    @ViewBuilder var content: Content
    
    /// Status Bar Window
    @State private var statusBarWindow: UIWindow?
    
    var body: some View {
        content
            .onAppear(perform: {
                if statusBarWindow == nil {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let statusBarWindow = UIWindow(windowScene: windowScene)
                        statusBarWindow.windowLevel = .statusBar
                        statusBarWindow.tag = WINDOW_TAG
                        
                        let controller = StatusBarViewController()
                        controller.view.backgroundColor = .clear
                        controller.view.isUserInteractionEnabled = false
                        
                        statusBarWindow.rootViewController = controller
                        statusBarWindow.isHidden = false
                        statusBarWindow.isUserInteractionEnabled = false
                        self.statusBarWindow = statusBarWindow
                    }
                }
            })
            .onDisappear(perform: {
                self.statusBarWindow?.rootViewController = nil
                self.statusBarWindow = nil
            })
    }
}

private class StatusBarViewController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

struct StatusBarContentView: View {
    @State private var statusBarStyle: StatusBarStyle = .defaults
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $statusBarStyle) {
                    ForEach(StatusBarStyle.allCases, id: \.rawValue) { style in
                        Text(style.rawValue)
                            .tag(style)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .onChange(of: statusBarStyle, initial: true) { oldValue, newValue in
                    /// Update Status bar style
                    UIApplication.shared.setStatusBarStyle(newValue.status)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

let WINDOW_TAG = 0320

enum StatusBarStyle: String, CaseIterable {
    case defaults = "Default"
    case light = "Light"
    case dark = "Dark"
    
    var status: UIStatusBarStyle {
        switch self {
            case .defaults:
                return .default
            case .light:
                return .lightContent
            case .dark:
                return .darkContent
        }
    }
}

extension UIApplication {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBarWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.tag == WINDOW_TAG }),
           let statusBarController = statusBarWindow.rootViewController as? StatusBarViewController
        {
            /// Update status bar style
            statusBarController.statusBarStyle = style
            /// Refresh changes
            statusBarController.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

#Preview(body: {
    StatusBarUpdateView()
})
