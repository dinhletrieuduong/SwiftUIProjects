//
//  ParallaxCarouselCard.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 26/01/2024.
//

import SwiftUI

struct ParallaxCarouselCard: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                HeaderView()
                
                VStack(alignment: .leading) {
                    Text("Hi Dylan")
                    Text("Where do you go?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                GeometryReader { proxy in
                    let size = proxy.size

                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(tripList) { card in
                                GeometryReader { proxy in
                                    let size = proxy.size
                                    let minX = min(proxy.frame(in: .scrollView).minX * 1.4, proxy.size.width * 1.4)
                                    Image(card.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .offset(x: -minX)
                                        .frame(width: size.width * 2.5)
                                        .frame(width: size.width, height: size.height)
                                        .overlay(content: {
                                            OverlayView(card: card)
                                        })
                                        .clipShape(.rect(cornerRadius: 20))
                                        .shadow(color: .black.opacity(0.15), radius: 8, x: 5, y: 10)
                                    
                                }
                                .frame(width: size.width - 60, height: size.height - 50)
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view.scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                            }
                        }
                        .padding(20)
                        .scrollTargetLayout()
                        .frame(height: size.height, alignment: .top)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                }
                .frame(height: 500)
                .padding(.horizontal, -15)
                .padding(.top, 10)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20) {
            Image(systemName: "") // (systemName: "line.3.horizontal")
                .font(.title)
            
            HStack {
                Image(systemName: "map")
                Text("Phan Thiet, Vietnam")

            }
            .opacity(0.5)
            
            Image("animoji4")
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .clipShape(Circle())
        }
    }
    
    @ViewBuilder
    func OverlayView(card: ParallaxCarouselCardModel) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [.clear, .clear, .clear, .black.opacity(0.1), .black.opacity(0.5), .black], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(card.title)")
                    .font(.title)
                    .bold()
                
                Text("\(card.subtitle)")
            }
            .foregroundStyle(.white)
            .padding()
            
        }
    }
    
}
struct ParallaxCarouselCardContentView: View {
    var body: some View {
        TabView {
            ParallaxCarouselCard()
                .tabItem {
//                    Image("home-smile")
//                        .resizable()
//                        .frame(width: 40, height: 40)
                }
            
            Text("Explore")
                .tabItem {
//                    Image("compass")
//                        .resizable()
//                        .frame(width: 40, height: 40)
                }
            
            Text("Heart")
                .tabItem {
//                    Image("heart")
//                        .resizable()
//                        .frame(width: 40, height: 40)
                }
            
            Text("Profile")
                .tabItem {
//                    Image("profile")
//                        .resizable()
//                        .frame(width: 40, height: 40)
                }
        }
        .tint(.black)
    }
}

#Preview {
    ParallaxCarouselCardContentView()
}
