////
////  NewYearAnim.swift
////  learnSwiftUI
////
////  Created by LAP14482 on 17/11/2021.
////
//
//import SwiftUI
//
//struct NewYearAnimation: View {
//    
//    @State private var newYear = false
//    
//    var body: some View {
//        ZStack {
//            backgroundColor
//            HStack {
//                ImageView(imageName: "20.square", color: Color.black)
//                
//                VStack {
//                    ImageView(imageName: "21.square", color: Color.green)
//                    ImageView(imageName: "20.square", color: Color.gray)
//                }
//                .offset(y: newYear ? 54 : -54)
//                .animation(Animation.easeInOut(duration: 1.5))
//                .onAppear {
//                    newYear = true
//                }
//            }
//            backgroundColor
//                .frame(width: 100, height: 100)
//                .offset(x: 54, y: -108)
//            
//            backgroundColor
//                .frame(width: 100, height: 100)
//                .offset(x: 54, y: 108)
//            
//            LottieView(filename: "fireworks3")
//                .opacity(newYear ? 1 : 0)
//                .animation(Animation/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/.delay(1.5))
//            
//        }
//        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//    }
//    
//    private var backgroundColor = Color.pink
//}
//
//struct Animation3_Previews: PreviewProvider {
//    static var previews: some View {
//        NewYearAnimation()
//    }
//}
//
//struct ImageView: View {
//    var imageName: String
//    var color: Color
//    var body: some View {
//        Image(systemName: imageName)
//            .resizable()
//            .frame(width: 100, height: 100)
//            .foregroundColor(color)
//    }
//}
