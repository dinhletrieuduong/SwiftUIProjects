//
//  DummyControlControl.swift
//  DummyControl
//
//  Created by Dinh Le Trieu Duong on 14/7/24.
//

import AppIntents
import SwiftUI
import WidgetKit

struct DummyControlControl: ControlWidget {
    static let kind: String = "com.dltduong.SwiftUIPortal.DummyControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
//            ControlWidgetToggle(isOn: SharedManager.shared.isTurnedOn, action: DummyControlIntent()) { isTurnedOn in
//                Image(systemName: isTurnedOn ? "fan.fill" : "fan")
//                Text(isTurnedOn ? "Turned On" : "Turned Off")
//            } label: {
//                Text("Living Room")
//            }

            ControlWidgetButton(action: CaffeineUpdateTake(amount: 10.0)) {
                Image(systemName: "cup.and.saucer.fill")
                Text("Caffeine in Take")
                let amount = SharedManager.shared.caffeineInTake
                Text("\(String(format: "%.1f", amount)) mgs")
            }

        }
    }
}

struct CaffeineUpdateTake: AppIntent {
    static var title: LocalizedStringResource { "Update Caffeine In Take" }

    init() {
    }

    init(amount: Double) {
        self.amount = amount
    }

    @Parameter(title: "Amount Taken")
    var amount: Double

    func perform() async throws -> some IntentResult {
        SharedManager.shared.caffeineInTake += amount

        return .result()
    }
}

struct DummyControlIntent: SetValueIntent {
    static var title: LocalizedStringResource { "Turn On Living Room Fan" }

    @Parameter(title: "is Turned On")
    var value: Bool

    func perform() async throws -> some IntentResult {
        /// Updates Contents here
        SharedManager.shared.isTurnedOn = value

        return .result()
    }
}
