//
//  ContentView.swift
//  SwiftUIPortal
//
//  Created by Dylan on 14/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    let views: [AnyView] = [
        AnyView(SplitTheBillView()),
        AnyView(PokemonView()),
        AnyView(CircularProgressBarSampleView()), // TODO:
        AnyView(DetectNetworkContentView()),
        AnyView(OtpVerificationView()),
        AnyView(YoutubeOpeningAnimation()),
        AnyView(RippleAnimation()),
        AnyView(AWBreathAnimation()),
        AnyView(DownloadingView()),
        AnyView(AuthView()),
        AnyView(CustomMapView().frame(height: 500, alignment: .center)),
        AnyView(CustomTimePickerView()),
        AnyView(DatePickerView()),
        AnyView(LiquidSwipeHome()),
        AnyView(DashedHalvedCircularBar(circleProgress: 0.01, widthAndHeight: 300, progressColor: .blue)),
        AnyView(CircularProgressBase(circleProgress: 0.01, widthAndHeight: 100, labelSize: 15, lineWidth: 15, staticColor: .black, progressColor: .blue, showLabel: true)),
        AnyView(ActivityIndicator()),
        AnyView(TinderSwipableCardView()),
        
        
    ]
    let titleViews: [String] = [
        "Split The Bill",
        "Pokemon",
        "Circular Progress Bar",
        "Detect Network",
        "Verify OTP",
        "Youtube Opening",
        "Ripple Animation",
        "AW Breath Animation",
        "Downloading View",
        "Auth With Biometric",
        "Custom Map",
        "Custom Time Picker",
        "Date Picker",
        "Liquid Swipe Home",
        "Dashed Halved Circular Bar",
        "CircularProgressBase",
        "ActivityIndicator",
        "Tinder Swipable Card",
    ]
    
    var body: some View {
        SplitTheBillView()
//        NavigationView {
//            List {
//                ForEach(0..<views.count) { index in
//                    NavigationLink("\(titleViews[index])") {
//                        views[index].navigationTitle(titleViews[index])
//
//                    }
//                }
//            }
//            .navigationBarTitle("Home")
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
