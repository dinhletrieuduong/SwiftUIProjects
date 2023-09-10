//
//  heart.swift
//  learn
//
//  Created by LAP14482 on 25/07/2021.
//

import Foundation
import SwiftUI

struct LikeButton : View {
    @State private var isLiked = false;
    @State private var likeTxt = "3";
    @State private var likeOffset: CGFloat = 0;
    @State private var likeOpacity = 1.0;
    
    
    var body: some View {
        HStack {
            ZStack() {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                    .scaleEffect(0.7)
                    .foregroundColor(.gray)
                
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .scaleEffect(isLiked ? 1.0 : 0)
                    .foregroundColor(.pink)
                    .animation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 0))
                
            }
            .onTapGesture {
                isLiked.toggle()
//                incrementLikes()
            }
            
//            Spacer()
            
            Text(likeTxt)
                .font(.system(size: 50, weight: Font.Weight.bold))
                .foregroundColor(.gray)
                .opacity(likeOpacity)
                .offset(x: 0, y: likeOffset)
                .animation(Animation.linear(duration: 1))
                .padding()
        }
    }
}

