//
//  CustomLimitedTextField.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 29/04/2024.
//

import SwiftUI

struct DemoCustomLimitedTextField: View {
    
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            CustomLimitedTextField(
                config: .init(
                    limit: 40,
                    tint: .secondary,
                    autoResizes: true
                ),
                hint: "Type here",
                value: $text
            )
            .autocorrectionDisabled()
            .frame(maxHeight: 150)
        }
        .padding()
    }
}


struct CustomLimitedTextField: View {
    var config: Config
    var hint: String
    @Binding var value: String
    
    @FocusState private var isKeyboardShowing: Bool
    
    var progressColor: Color {
        return progress < 0.6 ? config.tint : progress == 1 ? .red: .orange
    }
    
    var progress: CGFloat {
        return max(min(CGFloat(value.count) / CGFloat(config.limit), 1), 0)
    }
    
    var body: some View {
        VStack(alignment: config.progressConfig.alignment, spacing: 12, content: {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: config.borderConfig.radius)
                    .fill(.clear)
                    .frame(height: config.autoResizes ? 0 : nil)
                    .contentShape(.rect(cornerRadius: config.borderConfig.radius))
                    .onTapGesture {
                        /// Show keyboard
                        isKeyboardShowing = true
                    }
                
                TextField(hint, text: $value, axis: .vertical)
                    .focused($isKeyboardShowing)
                    .onChange(of: value, initial: true) { oldValue, newValue in
                        guard !config.allowExcessTyping else { return }
                        value = String(value.prefix(config.limit))
                    }
                
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: config.borderConfig.radius)
                    .stroke(progressColor.gradient, lineWidth: config.borderConfig.width)
            }
            
            /// Progress bar / Text indicator
            HStack(spacing: 12) {
                if config.progressConfig.showsRing {
                    ZStack {
                        Circle()
                            .stroke(.ultraThinMaterial, lineWidth: 5)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(progressColor.gradient, lineWidth: 5)
                            .rotationEffect(.init(degrees: -90))
                    }
                    .frame(width: 20, height: 20)
                }
                
                if config.progressConfig.showsText {
                    Text("\(value.count)/\(config.limit)")
                        .foregroundStyle(progressColor.gradient)
                }
            }
        })
    }
    
    struct Config {
        var limit: Int
        var tint: Color = .blue
        var autoResizes: Bool = false
        var allowExcessTyping: Bool = false
        var progressConfig: ProgressConfig = .init()
        var borderConfig: BorderConfig = .init()
    }
    
    struct ProgressConfig {
        var showsRing: Bool = true
        var showsText: Bool = false
        var alignment: HorizontalAlignment = .trailing
    }
    
    struct BorderConfig {
        var show: Bool = false
        var radius: CGFloat = 12
        var width: CGFloat = 0.8
    }
    
}

#Preview {
    DemoCustomLimitedTextField()
}
