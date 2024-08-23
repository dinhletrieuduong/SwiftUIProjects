//
//  SheetContentView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 22/8/24.
//

import Foundation

import SwiftUI

enum Sheet: Identifiable, Hashable {
    case settings
    case contact(String)

    var id: Self { self }
}

struct SheetAction {
    typealias Action = (Sheet, (() -> Void)?) -> Void
    let action: Action

    func callAsFunction(_ sheet: Sheet, _ dismiss: (() -> Void)? = nil) {
        action(sheet, dismiss)
    }
}

struct ShowSheetKey: EnvironmentKey {
    static var defaultValue: SheetAction = SheetAction { _, _ in }
}

extension EnvironmentValues {
    var showSheet: (SheetAction) {
        get { self[ShowSheetKey.self] }
        set { self[ShowSheetKey.self] = newValue }
    }
}

struct SheetView: View {

    let sheet: Sheet

    var body: some View {
        switch sheet {
            case .settings:
                Text("Settings")
            case .contact(let name):
                Text("Contacting \(name)")
        }
    }
}

struct SheetContentView: View {

    @Environment(\.showSheet) private var showSheet

    private func settingsScreenDismissed() {
        print("settingsScreenDismissed")
    }

    var body: some View {
        VStack {
            Button("Show Settings Screen") {
                showSheet(.settings, settingsScreenDismissed)
            }

            Button("Show Contact Screen") {
                showSheet(.contact("John Doe"))
            }
        }
        .padding()
    }
}

#Preview {
    ContentViewContainer()
}

// THIS IS JUST FOR THE PREVIEWS
struct ContentViewContainer: View {

    @State private var selectedSheet: Sheet?
    @State private var onSheetDismiss: (() -> Void)?

    var body: some View {
        SheetContentView()
            .environment(\.showSheet, SheetAction(action: { sheet, dismiss in
                selectedSheet = sheet
                onSheetDismiss = dismiss
            }))
            .sheet(item: $selectedSheet, onDismiss: onSheetDismiss) { sheet in
                SheetView(sheet: sheet)
            }
    }
}

//LearnApp.swift
////
////  LearnApp.swift
////  Learn
////
////  Created by Mohammad Azam on 8/14/24.
////
//
//import SwiftUI
//
//@main
//struct LearnApp: App {
//
//    @State private var selectedSheet: Sheet?
//    @State private var onSheetDismiss: (() -> Void)?
//
//    var body: some Scene {
//        WindowGroup {
//            NavigationStack {
//                SheetContentView()
//                    .environment(\.showSheet, SheetAction(action: { sheet, dismiss in
//                        selectedSheet = sheet
//                        onSheetDismiss = dismiss
//                    }))
//                    .sheet(item: $selectedSheet, onDismiss: onSheetDismiss) { sheet in
//                        SheetView(sheet: sheet)
//                    }
//            }
//        }
//    }
//}
