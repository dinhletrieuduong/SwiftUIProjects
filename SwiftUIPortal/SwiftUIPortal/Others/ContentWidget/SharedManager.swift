//
//  SharedManager.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 14/7/24.
//

import SwiftUI

class SharedManager {
    static let shared = SharedManager()
    var isTurnedOn: Bool = false

    var caffeineInTake: CGFloat = 0
}
