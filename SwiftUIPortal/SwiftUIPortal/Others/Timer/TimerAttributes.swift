//
//  TimerAttributes.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 22/02/2024.
//

import ActivityKit

struct TimerAttributes: ActivityAttributes {
    
    public typealias TimeTrackingStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var duration: String
        var progress: Double
    }
    
    var name: String
}
