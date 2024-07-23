//
//  DummyControlBundle.swift
//  DummyControl
//
//  Created by Dinh Le Trieu Duong on 14/7/24.
//

import WidgetKit
import SwiftUI

@main
struct DummyControlBundle: WidgetBundle {
    var body: some Widget {
        DummyControl()
        DummyControlControl()
    }
}
