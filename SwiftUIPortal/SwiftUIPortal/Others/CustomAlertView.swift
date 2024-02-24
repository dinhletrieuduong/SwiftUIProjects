//
//  CustomAlertView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 23/02/2024.
//

import SwiftUI

struct CustomAlertView<T: Hashable, M: View>: View {
    
    @Namespace private var namespace
    
    @Binding private var isPresented: Bool
    @State private var transition: AnyTransition
    
    @State private var titleKey: LocalizedStringKey
    @State private var actionTextKey: LocalizedStringKey
    
    private var data: T?
    private var actionWithValue: ((T) -> ())?
    private var messageWithValue: ((T) -> M)?
    
    private var action: (() -> ())?
    private var message: (() -> M)?
    
    // Animation
    @State private var isAnimating = false
    private let animationDuration = 0.5
    
    init(
        _ titleKey: LocalizedStringKey,
        _ isPresented: Binding<Bool>,
        presenting data: T?,
        transition: AnyTransition = .move(edge: .bottom),
        actionTextKey: LocalizedStringKey,
        action: @escaping (T) -> (),
        @ViewBuilder message: @escaping (T) -> M
    ) {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _isPresented = isPresented
        _transition = State(wrappedValue: transition)
        
        self.data = data
        self.action = nil
        self.message = nil
        self.actionWithValue = action
        self.messageWithValue = message
    }
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(isPresented ? 0.6 : 0)
                .zIndex(1)
            
            if isAnimating {
                VStack {
                    VStack {
                        /// Title
                        Text(titleKey)
                            .font(.title2).bold()
                            .foregroundStyle(.tint)
                            .padding(8)
                        
                        /// Message
                        Group {
                            if let data, let messageWithValue {
                                messageWithValue(data)
                            } else if let message {
                                message()
                            }
                        }
                        .multilineTextAlignment(.center)
                        
                        /// Buttons
                        HStack {
                            CancelButton
                            DoneButton
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.background)
                    .cornerRadius(35)
                }
                .padding()
                .transition(transition)
                .zIndex(2)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            show()
        }
    }
    
    // MARK: Buttons
    var CancelButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Cancel")
                .font(.headline)
                .foregroundStyle(.tint)
                .padding()
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .background(Material.regular)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }
    
    var DoneButton: some View {
        Button {
            dismiss()
            
            if let data, let actionWithValue {
                actionWithValue(data)
            } else if let action {
                action()
            }
        } label: {
            Text(actionTextKey)
                .font(.headline).bold()
                .foregroundStyle(Color.white)
                .padding()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .background(.tint)
                .clipShape(RoundedRectangle(cornerRadius: 30.0))
        }
    }
    
    func dismiss() {
        if #available(iOS 17.0, *) {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            } completion: {
                isPresented = false
            }
        } else {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                isPresented = false
            }
        }
    }
    
    func show() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            isAnimating = true
        }
    }
}

// MARK: - Overload
extension CustomAlertView where T == Never {
    
    init(
        _ titleKey: LocalizedStringKey,
        _ isPresented: Binding<Bool>,
        transition: AnyTransition = .move(edge: .bottom),
        actionTextKey: LocalizedStringKey,
        action: @escaping () -> (),
        @ViewBuilder message: @escaping () -> M
    ) where T == Never {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _transition = State(wrappedValue: transition)
        _isPresented = isPresented
        
        self.data = nil
        self.action = action
        self.message = message
        self.actionWithValue = nil
        self.messageWithValue = nil
    }
}

// MARK: - Preview
struct CustomAlertPreview: View {
    @State private var isPresented = false
    @State private var test = "Some Value"
    
    var body: some View {
        VStack {
            Button("Show Alert") {
                isPresented = true
            }
            .customAlert(
                "Alert Title",
                isPresented: $isPresented,
                presenting: test,
                transition: .move(edge: .bottom).combined(with: .opacity),
                actionText: "Yes, Done"
            ) { value in
                // Action...
            } message: { value in
                Text("Showing alert for \(value)… And adding a long text for preview.")
            }
        }
    }
}

extension View {
    /// Presents an alert with a message when a given condition is true, using a localized string key for a title.
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to present the alert.
    ///   - data: An optional binding of generic type T value, this data will populate the fields of an alert that will be displayed to the user.
    ///   - actionText: The key for the localized string that describes the text of alert's action button.
    ///   - action: The alert’s action given the currently available data.
    ///   - message: A ViewBuilder returning the message for the alert given the currently available data.
    func customAlert<M, T: Hashable>(
        _ titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        presenting data: T?,
        transition: AnyTransition = .move(edge: .bottom),
        actionText: LocalizedStringKey,
        action: @escaping (T) -> (),
        @ViewBuilder message: @escaping (T) -> M
    ) -> some View where M: View {
        fullScreenCover(isPresented: isPresented) {
            CustomAlertView(
                titleKey,
                isPresented,
                presenting: data,
                transition: transition,
                actionTextKey: actionText,
                action: action,
                message: message
            )
            .presentationBackground(.clear)
        }
        .transaction { transaction in
            // disable the default FullScreenCover animation
            transaction.disablesAnimations = true
            
            // add custom animation for presenting and dismissing the FullScreenCover
            transaction.animation = .linear(duration: 0.1)
        }
    }
    
    /// Presents an alert with a message when a given condition is true, using a localized string key for a title.
    /// - Parameters:
    ///   - titleKey: The key for the localized string that describes the title of the alert.
    ///   - isPresented: A binding to a Boolean value that determines whether to present the alert.
    ///   - actionText: The key for the localized string that describes the text of alert's action button.
    ///   - action: Returning the alert’s actions.
    ///   - message: A ViewBuilder returning the message for the alert.
    func customAlert<M>(
        _ titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        transition: AnyTransition = .move(edge: .bottom),
        actionText: LocalizedStringKey,
        action: @escaping () -> (),
        @ViewBuilder message: @escaping () -> M
    ) -> some View where M: View {
        fullScreenCover(isPresented: isPresented) {
            CustomAlertView(
                titleKey,
                isPresented,
                transition: transition,
                actionTextKey: actionText,
                action: action,
                message: message
            )
            .presentationBackground(.clear)
        }
        .transaction { transaction in
            // disable the default FullScreenCover animation
            transaction.disablesAnimations = true
            
            // add custom animation for presenting and dismissing the FullScreenCover
            transaction.animation = .linear(duration: 0.1)
        }
    }
}

#Preview {
    VStack {
        CustomAlertPreview()
    }
}
