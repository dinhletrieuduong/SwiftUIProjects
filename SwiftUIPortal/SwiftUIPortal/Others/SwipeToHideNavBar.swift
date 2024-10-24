//
//  SwipeToHideNavBar.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 30/12/2023.
//

import SwiftUI


struct SwipeToHideNavBarView: View {
    @State private var hideNavBar: Bool = false
    var body: some View {
        
            List {
                ForEach(1...50, id: \.self) { index in
                    NavigationLink {
                        List {
                            ForEach(1...50, id: \.self) { j in
                                Text("Sub Item \(j)")
                            }
                        }
                        .navigationTitle("Item \(index)")
                        .hideNavBarOnSwipe(false)
                    } label: {
                        Text("List item \(index)")
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Swipe2HideNavBar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        hideNavBar.toggle()
                    }, label: {
                        Image(systemName: hideNavBar ? "eye.slash" : "eye")
                    })
                }
            }
            .hideNavBarOnSwipe(hideNavBar)
        
    }
}

/// Custom View Modifier
private extension View {
    @ViewBuilder
    func hideNavBarOnSwipe(_ isHidden: Bool) -> some View {
        self
            .modifier(NavBarModifier(isHidden: isHidden))
    }
}

private struct NavBarModifier: ViewModifier {
    var isHidden: Bool
    @State private var isNavBarHidden: Bool?
    func body(content: Content) -> some View {
        content
            .onChange(of: isHidden, initial: true, { oldValue, newValue in
                isNavBarHidden = newValue
            })
            .onDisappear {
                isNavBarHidden = nil
            }
            .background {
                NavigationControllerExtractor(isHidden: isHidden)
            }
    }
}

/// Extracting UINavigationViewController from SwiftUI view
private struct NavigationControllerExtractor: UIViewRepresentable {
    var isHidden: Bool?
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            /// Extract the associated root UIViewController from the UIView with a custom extension.
            /// The associated view controller will hold the UINavigationController and with that, we can make customizations.
            ///
            if let hostView = uiView.superview?.superview,
               let parentController = hostView.parentController {
                if let isHidden {
                    parentController.navigationController?.hidesBarsOnSwipe = isHidden
                }
            }
        }
    }
}


#Preview {
    SwipeToHideNavBarView()
}
