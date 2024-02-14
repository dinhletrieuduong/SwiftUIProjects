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

enum Route: Hashable, Equatable, CaseIterable {
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
    case customTimePickerView
    case customMapView
    case rippleAnimation
    
    case cardCreation
    case sequenceAnimation
    case tapBarT
    case customBottomTabBar
    case animatedSFTabView
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
    case activityRing
    case musicPlayer
    case qrScanner
    case floatingButton
    case typeWriterText
    case shimmerView
    case animatedDot
    case tabCategory
    case morphingDrag
    case passcode
    case customLayoutTag
    case chatGPTLoginAnimation
    case interactivePopGesture
    case themeChange
    case boomerangCards
    case professionSideMenu
    case coverFlow
    case gitHubAnimation
    
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
            case .customTimePickerView:
                return "Custom Date Time Picker"
            case .customMapView:
                return "Custom Map"
            case .rippleAnimation:
                return "Ripple Animation"
            case .cardCreation:
                return "Card Creation"
            case .sequenceAnimation:
                return "Sequence Animation"
            case .tapBarT:
                return "Tap Bar T"
            case .customBottomTabBar:
                return "Custom Bottom Tab Bar"
            case .animatedSFTabView:
                return "Animated SF Tab"
            case .transparentBlurView:
                return "Transparent Blur View"
            case .liquidSwipe:
                return "Liquid Swipe"
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
            case .activityRing:
                return "Activity Ring"
            case .musicPlayer:
                return "Music Player"
            case .qrScanner:
                return "QR Scanner"
            case .floatingButton:
                return "Floating Button"
            case .typeWriterText:
                return "Type Writer"
            case .shimmerView:
                return "Shimmer View"
            case .animatedDot:
                return "Animated Dot"
            case .tabCategory:
                return "Tab Category"
            case .morphingDrag:
                return "Morphing Drag"
            case .passcode:
                return "Passcode"
            case .customLayoutTag:
                return "Custom Layout Tag"
            case .chatGPTLoginAnimation:
                return "ChatGPT Login"
            case .interactivePopGesture:
                return "Interactive Pop Gesture"
            case .themeChange:
                return "Theme Change"
            case .boomerangCards:
                return "Boomerang Cards"
            case .professionSideMenu:
                return "Profession Side Menu"
            case .coverFlow:
                return "Cover Flow"
            case .gitHubAnimation:
                return "Github Animation"
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
                DownloadingDemoView()
            case .awBreath:
                AWBreathAnimation()
            case .tinderSwipableCard:
                TinderSwipableCardView()
            case .customTimePickerView:
                DatePickerView()
            case .customMapView:
                CustomMapView().frame(height: 500, alignment: .center)
            case .rippleAnimation:
                RippleAnimation()
//            case .errorScreen(let error):
//                Text("Error: \(error.localizedDescription)")
            case .empty:
                Text("Empty Screen")
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
                CustomPagingSliderDemoView()
                
            case .activityRing:
                ActivityRingContentView()
            case .musicPlayer:
                MusicPlayerView()
            case .qrScanner:
                QRScannerView()
            case .floatingButton:
                FloatingButtonView {
                    
                }
            case .typeWriterText:
                TypewriterTextView(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", font: .body)
                
            case .shimmerView:
                ShimmerEffectDemo()
            case .animatedDot:
                AnimatedDotView()
            case .tabCategory:
                TabCategoryViewDemo()
            case .morphingDrag:
                MorphingDragView {
                    Rectangle()
                }
            case .passcode:
                PasscodeDemoView()
            case .customLayoutTag:
                CustomLayoutTagView()
            case .chatGPTLoginAnimation:
                ChatGPTLoginAnimationView()
                
            case .customBottomTabBar:
                CustomBottomTabBar()
            case .animatedSFTabView:
                AnimatedSFTabView()
            case .interactivePopGesture:
                InteractivePopGestureDemoView()
            case .themeChange:
                ThemeChangeDemoView()
            case .boomerangCards:
                BoomerangCardsDemoView()
            case .professionSideMenu:
                ProfessionalSideMenuDemoView()
            case .coverFlow:
                CoverFlowDemoView()
            case .gitHubAnimation:
                GitHubAnimationView()
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

