//
//  Router.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 10/09/2023.
//

import SwiftUI

enum AppError: Error, Hashable {
    case badRequest
    case error(message: String)
}

enum Route: Hashable, Equatable, Identifiable, CaseIterable {
    var id: Self {
        return self
    }
    
    init?(id : Int) {
        switch id {
            case 1:
                self = .home
            case 2:
                self = .pokemonView
            case 3:
                self = .detectNetwork
            default:
                return nil
        }
    }
    
    case home // Start round
    case pokemonView
    case detectNetwork
    case splitBill
    case downloadingView
    case awBreath
    
    case tinderSwipableCard
    case activityIndicator
    case datePickerView
    case customTimePickerView
    case customMapView
    case rippleAnimation
    
    case circularProgressBar
    case circularProgressBase
    case dashedHalvedCircularBar
    case cardCreation
    case sequenceAnimation
    case tapBarT
    case transparentBlurView
    case liquidSwipe
    
    case authBiometricView
    case optVerification
    case youtubeOpeningAnimation
    
    case flowerPetals
    
    case watchHeartAnimation
    case infiniteCarouselView
    case statusBarUpdateView
    case parallaxCardView
    
    case calmaria
    case customToast
    case gradientCard
    case fbReactions
    
    case animatedPageIndicator
    
    case empty
    

    var title: String {
        switch self {
            case .home:
                return "Home"
            case .pokemonView:
                return "Pokemon"
            case .detectNetwork:
                return "Detect Network"
            case .splitBill:
                return "Split The Bill"
            case .downloadingView:
                return "Downloading View"
            case .awBreath:
                return "AW Breath Animation"
            case .empty:
                return "Empty Screen"
            case .tinderSwipableCard:
                return "Tinder Swipable Card"
            case .activityIndicator:
                return "ActivityIndicator"
            case .datePickerView:
                return "Custom Date Picker"
            case .customTimePickerView:
                return "Custom Time Picker"
            case .customMapView:
                return "Custom Map"
            case .rippleAnimation:
                return "Ripple Animation"
            case .circularProgressBar:
                return "Circular Progress Bar"
            case .circularProgressBase:
                return "Circular Progress Base"
            case .cardCreation:
                return "Card Creation"
            case .sequenceAnimation:
                return "Sequence Animation"
            case .tapBarT:
                return "Tap Bar T"
            case .transparentBlurView:
                return "Transparent Blur View"
            case .liquidSwipe:
                return "Liquid Swipe"
            case .dashedHalvedCircularBar:
                return "Dashed Halved Circular Bar"
            case .authBiometricView:
                return "Auth With Biometric"
            case .optVerification:
                return "Verify OTP"
            case .youtubeOpeningAnimation:
                return "Youtube Opening"
            case .flowerPetals:
                return "Flower Petals"
            case .watchHeartAnimation:
                return "WatchOS 10 Heart App Animation"
            case .infiniteCarouselView:
                return "Infinite Carousel View"
            case .statusBarUpdateView:
                return "Status Bar Update View"
            case .parallaxCardView:
                return "Parallax Card View"
            case .calmaria:
                return "Calmaria"
            case .customToast:
                return "Custom Toast"
            case .gradientCard:
                return "Custom Gradient Card"
            case .fbReactions:
                return "Facebook Reactions"
            case .animatedPageIndicator:
                return "Paging Indicator"
        }
    }
    
    @ViewBuilder
    func destination() -> some View {
        switch self {
            case .home:
                Text("Home")
            case .pokemonView:
                PokemonView()
            case .detectNetwork:
                DetectNetworkContentView()
            case .splitBill:
                SplitTheBillView()
            case .downloadingView:
                DownloadingView()
            case .awBreath:
                AWBreathAnimation()
            case .tinderSwipableCard:
                TinderSwipableCardView()
            case .activityIndicator:
                ActivityIndicator()
            case .datePickerView:
                DatePickerView()
            case .customTimePickerView:
                CustomTimePickerView()
            case .customMapView:
                CustomMapView().frame(height: 500, alignment: .center)
            case .rippleAnimation:
                RippleAnimation()
//            case .errorScreen(let error):
//                Text("Error: \(error.localizedDescription)")
            case .empty:
                Text("Empty Screen")
            case .circularProgressBar:
                CircularProgressBarSampleView()
            case .circularProgressBase:
                CircularProgressBase(circleProgress: 0.01, widthAndHeight: 100, labelSize: 15, lineWidth: 15, staticColor: .black, progressColor: .blue, showLabel: true)
            case .cardCreation:
                CardCreationView()
            case .sequenceAnimation:
                SequenceAnimationHome()
            case .tapBarT:
                TapBarT()
            case .transparentBlurView:
                if #available(iOS 17.0, *) {
                    TransparentBlurView()
                } else {
                    // Fallback on earlier versions
                }
            case .liquidSwipe:
                LiquidSwipeHome()
            case .dashedHalvedCircularBar:
                DashedHalvedCircularBar(circleProgress: 0.01, widthAndHeight: 300, progressColor: .blue)
            case .authBiometricView:
                AuthView()
            case .optVerification:
                OtpVerificationView()
            case .youtubeOpeningAnimation:
                YoutubeOpeningAnimation()
            case .flowerPetals:
                FlowerPetals()

            case .watchHeartAnimation:
                if #available(iOS 17.0, *) {
                    HeartAnimationView()
                        .preferredColorScheme(.dark)
                } else {
                    EmptyView()
                }
            case .infiniteCarouselView:
                InfiniteCarouselView()
            case .statusBarUpdateView:
                StatusBarUpdateView() // This should be run alone without superview
                
            case .parallaxCardView:
                ParallaxCardView()
                
                
            case .calmaria:
                CalmariaView()
            case .customToast:
                CustomToastView()
            case .gradientCard:
                GradientCardAnimation()
            case .fbReactions:
                FBReaction()
                
            case .animatedPageIndicator:
                AnimatedPageIndicator()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case home // Start round
        case pokemonView
        case detectNetwork
        case splitBill
        case downloadingView
        case awBreath
        
        case tinderSwipableCard
        case activityIndicator
        case datePickerView
        case customTimePickerView
        case customMapView
        case rippleAnimation
        
        case circleProgressBar
        case circularProgressBase
        case cardCreation
        case sequenceAnimation
        case tapBarT
        case transparentBlurView
        case liquidSwipe
        case parallaxCardView
        
        case calmaria
        case customToast
        case gradientCard
        case fbReactions
        
        case errorScreen
        case empty
    }
    
    public static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
            case (.home, .home),
                (.pokemonView, .pokemonView),
                (.awBreath, .awBreath),
                (.detectNetwork, .detectNetwork),
                (.splitBill, .splitBill),
                (.downloadingView, .downloadingView):
                return true
                
                //            case let (.errorScreen(error1), .errorScreen(error2)):
                //                return error1.localizedDescription == error2.localizedDescription
                
            default:
                return false
        }
    }
    
}

/// This class requires watchOS 9.0 or above for using
@available(watchOS 9.0, *)
final class Router: ObservableObject {
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Route) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}

