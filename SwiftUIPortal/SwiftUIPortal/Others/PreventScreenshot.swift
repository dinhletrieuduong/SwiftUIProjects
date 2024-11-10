//
//  PreventScreenshot.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 26/10/24.
//

import SwiftUI

struct ScreenshotPreventView<Content: View>: View {
    var content: Content

    @State private var hostingController: UIHostingController<Content>?
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        _ScreenshotPreventHelper(hostingController: $hostingController)
            .overlay {
                GeometryReader {
                    let size = $0.size

                    Color.clear
                        .preference(key: SizeKey.self, value: size)
                        .onPreferenceChange(SizeKey.self) { value in
                            if value != .zero {

                                if hostingController == nil {
                                    hostingController = UIHostingController(rootView: content)
                                    hostingController?.view.backgroundColor = .clear
                                    hostingController?.view.tag = 1009
                                    hostingController?.view.frame = .init(origin: .zero, size: value)
                                } else {
                                    /// Sometimes the View size may updated, in that case updating the UIView Size
                                    hostingController?.view.frame = .init(origin: .zero, size: value)
                                }
                            }
                        }

                }
            }
    }
}

#Preview {
    ScreenshotPreventView {
        GeometryReader {
            let size = $0.size
            Image(.avatar3)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(topLeadingRadius: 55, bottomTrailingRadius: 55))
        }
        .padding(15)
        .padding(.vertical, 50)
    }
}

fileprivate struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize { .zero }

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
fileprivate struct _ScreenshotPreventHelper<Content: View>: UIViewRepresentable {
    @Binding var hostingController: UIHostingController<Content>?

    func makeUIView(context: Context) -> UIView {
        let secureField = UITextField()
        secureField.isSecureTextEntry = true

        if let textLayoutView = secureField.subviews.first {
            return textLayoutView
        }

        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        /// Adding Hosting View as a Subview to the TextLayout View
        if let hostingController = hostingController, !uiView.subviews.contains(where: { $0.tag == 1009 }) {
            /// Adding Hosting View for one time
            uiView.addSubview(hostingController.view)
        }
    }
}
