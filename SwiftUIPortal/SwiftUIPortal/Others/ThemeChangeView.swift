//
//  ThemeChangeView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 12/02/2024.
//

import SwiftUI

let colorMoon = Color(hex: "8D86FF")
let colorSun = Color(hex: "FF8319")

struct ThemeChangeDemoView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var changeTheme: Bool = false
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    var body: some View {
        List {
            Section("Appearance") {
                Button("Change Theme") {
                    changeTheme.toggle()
                }
            }
        }
        .preferredColorScheme(userTheme.colorScheme)
        .sheet(isPresented: $changeTheme, content: {
            ThemeChangeView(scheme: colorScheme)
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
        
    }
}

struct ThemeChangeView: View {
    var scheme: ColorScheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    
    @Namespace private var animation
    
    @State private var circleOffset: CGSize
    
    init(scheme: ColorScheme) {
        self.scheme = scheme
        let isDark = scheme == .dark
        
        self._circleOffset = .init(initialValue: .init(width: isDark ? 30 : 150, height: isDark ? -25 : -150))
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Circle()
                .fill(userTheme.color(scheme).gradient)
                .frame(width: 150, height: 150)
                .mask {
                    /// Inverted Mask
                    Rectangle()
                        .overlay {
                            Circle()
                                .offset(circleOffset)
                                .blendMode(.destinationOut)
                            
                        }
                }
            
            Text("Choose a Style")
                .font(.title2.bold())
                .padding(.top, 25)
            
            Text("Pop or subtle, Day or Night.\nCustomize your interface.")
                .multilineTextAlignment(.center)
            
            HStack(spacing: 0) {
                ForEach(Theme.allCases, id: \.rawValue) { theme in
                    Text(theme.rawValue)
                        .padding(.vertical, 10)
                        .frame(width: 100)
                        .background {
                            ZStack {
                                if userTheme == theme {
                                    Capsule()
                                        .fill(Color("ThemeBG"))
                                        .matchedGeometryEffect(id: "ACTIVE_THEME_TAB", in: animation)
                                    
                                }
                            }
                            .animation(.snappy, value: userTheme)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            userTheme = theme
                        }
                }
            }
            .padding(3)
            .background(.primary.opacity(0.06), in: .capsule)
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 410)
        .background(Color("ThemeBG"))
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal, 15)
        .environment(\.colorScheme, scheme)
        .onChange(of: scheme, initial: false) { _, newValue in
            let isDark = newValue == .dark
            withAnimation(.bouncy(duration: 0.6)) {
                self.circleOffset = .init(width: isDark ? 30 : 150, height: isDark ? -25 : -150)
            }
        }
    }
}

enum Theme: String, CaseIterable {
    case systemDefault = "Default"
    case dark = "Dark"
    case light = "Light"
    
    func color(_ scheme: ColorScheme) -> Color {
        switch self {
            case .systemDefault:
                return scheme == .dark ? colorMoon : colorSun
            case .light:
                return colorSun
            case .dark:
                return colorMoon
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
            case .systemDefault:
                return nil
            case .dark:
                return .dark
            case .light:
                return .light
        }
    }
}

#Preview {
    ThemeChangeDemoView()
}
