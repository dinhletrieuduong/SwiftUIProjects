////
////  LottieView.swift
////  learnSwiftUI
////
////  Created by LAP14482 on 17/11/2021.
////
//
//import Lottie
//
//struct LottieView: UIViewRepresentable {
//    
//    let animationView = AnimationView()
//    var filename = "LottieLogo2"
//    
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        
//        let animation = Animation.named(filename)
//        animationView.animation = animation
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .repeat(3.0)
//        
//        animationView.play()
//        
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(animationView)
//        
//        NSLayoutConstraint.activate([
//            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
//            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            animationView.topAnchor.constraint(equalTo: view.topAnchor)
//        ])
//        
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        
//    }
//    
//}
//
