//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by Dinh Le Trieu Duong on 22/02/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            LiveActivityView(state: context.state)
                .activitySystemActionForegroundColor(Color.primary)
        } dynamicIsland: { context in

            DynamicIsland {
//                VStack {
//                    DynamicIslandExpandedRegion(.leading) {
//                        Image(systemName: "timer.circle.fill")
//                            .resizable()
//                            .frame(width: 44.0, height: 44.0)
//                            .foregroundColor(Color.primary)
//                    }
                
                    expandedContent(state: context.state)
//                }
            } compactLeading: {
                Image(systemName: "timer")
                    .transition(.identity)
                    .foregroundColor(Color.primary)
                    .padding(8)
            } compactTrailing: {
                Text(context.state.duration)
                    .minimumScaleFactor(0.8)
                    .contentTransition(.numericText())
                    .monospacedDigit()
                    .foregroundColor(Color.primary)
                    .padding(8)
            } minimal: {
                Image(systemName: "timer")
                    .foregroundColor(Color.primary)
            }
        }
    }
    
    @DynamicIslandExpandedContentBuilder
    private func expandedContent(state: TimerAttributes.ContentState) -> DynamicIslandExpandedContent<some View> {
        DynamicIslandExpandedRegion(.leading) {
            Image(systemName: "timer.circle.fill")
                .resizable()
                .frame(width: 44.0, height: 44.0)
                .foregroundColor(Color.primary)
        }
        DynamicIslandExpandedRegion(.center) {
            VStack {
                Text(state.duration + " remaining")
                    .font(.title)
                    .minimumScaleFactor(0.8)
                    .contentTransition(.numericText())
                Spacer()
                Button {
                    //TODO: End the activity
                } label: {
                    Label("Stop", systemImage: "stop.circle")
                        .font(.body.bold())
                }
                .foregroundColor(Color.white)
                .background(Color.primary)
                .clipShape(Capsule())
                .padding(.horizontal)
                .padding(.vertical, 8)
                .lineLimit(1)
            }
            .id(state)
            .transition(.identity)
        }
    }
}
