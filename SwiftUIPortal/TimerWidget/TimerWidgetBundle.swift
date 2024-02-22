//
//  TimerWidgetBundle.swift
//  TimerWidget
//
//  Created by Dinh Le Trieu Duong on 22/02/2024.
//

import WidgetKit
import SwiftUI

@main
struct TimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimerWidget()
        TimerWidgetLiveActivity()
    }
}
