//
//  LiveActivityManager.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 22/02/2024.
//

import ActivityKit
import Foundation

class LiveActivityManager {
    
    @discardableResult
    func startActivity(duration: TimeInterval, progress: Double) -> Activity<TimerAttributes>? {
        var activity: Activity<TimerAttributes>?
        var attributes = TimerAttributes(name: "Timer")
        
        do {
            let state = TimerAttributes.ContentState(
                duration: duration.format(using: [.minute, .second]),
                progress: progress
            )
            activity = try Activity<TimerAttributes>.request(
                attributes: attributes,
                contentState: state,
                pushType: nil
            )
        } catch {
            print(error.localizedDescription)
        }
        return activity
    }
    
    func updateActivity(activity: String, duration: TimeInterval, progress: Double) {
        Task {
            let contentState = TimerAttributes.ContentState(
                duration: duration.format(using: [.minute, .second]),
                progress: progress
            )
            let activity = Activity<TimerAttributes>.activities.first(where: { $0.id == activity })
            await activity?.update(using: contentState)
        }
    }
    
    func endActivity() {
        Task {
            for activity in Activity<TimerAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
}

extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
}
