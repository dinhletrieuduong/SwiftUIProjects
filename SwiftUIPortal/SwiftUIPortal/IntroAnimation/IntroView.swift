//
//  IntroView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 04/09/2023.
//

import SwiftUI

struct IntroView: View {
    // MARK: Animation Properties
    @State var showWalkThroughScreens: Bool = false
    @State var currentIndex: Int = 0
    @State var showHomeView: Bool = false
    
    let blueColor = Color(hex: "0E2954")
    
    var body: some View {
        ZStack {
            if !showHomeView {
                ZStack(content: {
                    Color(hex: "919ce5")
                        .opacity(0.99)
                        .ignoresSafeArea()
                    
                    IntroScreen()
                    
                    WalkThroughScreens()
                    
                    NavBar()
                })
                .animation(.interactiveSpring(response: 1.1, dampingFraction: 0.85, blendDuration: 0.85), value: showWalkThroughScreens)
                .transition(.move(edge: .leading))
            }
            else {
                IntroHomeView()
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showHomeView)
    }
    
    // MARK: WalkThrough Screens
    @ViewBuilder
    func WalkThroughScreens() -> some View {
        let isLast = currentIndex == intros.count
        
        GeometryReader {
            let size = $0.size
            
            ZStack {
                ForEach(intros.indices, id: \.self) { index in
                    ScreenView(size: size, index: index)
                }
                
                WelcomeView(size: size, index: intros.count)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Next Button
            .overlay(alignment: .bottom) {
                /// Converting the next button into signup button
                ZStack {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .scaleEffect(!isLast ? 1 : 0.001)
                        .opacity(!isLast ? 1 : 0)
                    
                    HStack {
                        Text("Sign Up")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "arrow.right")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        
                    }
                    .padding(.horizontal, 15)
                    .scaleEffect(isLast ? 1 : 0.001)
                    .frame(height: isLast ? nil : 0)
                    .opacity(isLast ? 1 : 0)
                }
                
                .frame(width: isLast ? size.width/1.5 : 55, height: isLast ? 50 : 55)
                    .foregroundStyle(.white)
                    .background {
                        RoundedRectangle(cornerRadius: isLast ? 10 : 30, style: isLast ? .continuous : .circular)
                            .fill(blueColor)
                    }
                    .onTapGesture {
                        if currentIndex == intros.count {
                            /// Sign up action
                            showHomeView = true
                        } else {
                            currentIndex += 1
                        }
                    }
                    .offset(y: isLast ? -40 : -60)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5), value: isLast)
            }
            .overlay(alignment: .bottom) {
                // bottom sign in button
                let isLast = currentIndex == intros.count
                HStack(spacing: 10) {
                    Text("Already have an account?")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.secondary)
                    
                    Button("Login") {
                        
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(blueColor)
                }
                .offset(y: isLast ? -12 : 100)
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5), value: isLast)
            }
            .offset(y: showWalkThroughScreens ? 0 : size.height)
        }
    }
    
    @ViewBuilder
    func ScreenView(size: CGSize, index: Int) -> some View {
        let intro = intros[index]
        
        VStack(spacing: 10, content: {
            Text(intro.title)
                .font(.system(size: 28, weight: .bold))
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Text(index == 0 ? dummyText : (index == 1 ? dummyText1 : dummyText2))
                .font(.system(size: 14, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Image(intro.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250, alignment: .top)
                .padding(.horizontal, 20)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
        })
    }
    
    @ViewBuilder
    func WelcomeView(size: CGSize, index: Int) -> some View {
        
        VStack(spacing: 10, content: {
            Image("welcome")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 250, alignment: .top)
                .padding(.horizontal, 20)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)
            
            Text("Welcome")
                .font(.system(size: 28, weight: .bold))
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)
            
            Text("Stay organized and live stress-free with \n this app.")
                .font(.system(size: 14, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)
            
        })
        .offset(y: -30)
    }
    
    @ViewBuilder
    func NavBar() -> some View {
        let isLast = currentIndex == intros.count
        
        HStack(content: {
            Button {
                /// If greater than zero, then eliminating index
                if currentIndex > 0 {
                    currentIndex -= 1
                } else {
                    showWalkThroughScreens.toggle()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(blueColor)
            }
            
            Spacer(minLength: 0)
            
            Button {
                currentIndex = intros.count
            } label: {
                Text("Skip")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(blueColor)
            }
            .opacity(isLast ? 0 : 1)
            .animation(.easeInOut, value: isLast)
            
        })
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .frame(maxHeight: .infinity, alignment: .top)
        .offset(y: showWalkThroughScreens ? 0 : -120)
    }
    
    @ViewBuilder
    func IntroScreen() -> some View {
        GeometryReader(content: {
            let size = $0.size
            
            VStack(spacing: 10, content: {
                Image("Intro")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height/2)
                
                Text("Clear head")
                    .fontWeight(.semibold)
                    .font(.system(size: 27))
                    .padding(.top, 55)
                
                Text(dummyText)
                    .fontWeight(.regular)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text("Let's Begin")
                    .fontWeight(.regular)
                    .font(.system(size: 14))
                    .padding(.horizontal,40)
                    .padding(.vertical, 14)
                    .foregroundStyle(.white)
                    .background {
                        Capsule()
                            .fill(blueColor)
                    }
                    .onTapGesture {
                        showWalkThroughScreens.toggle()
                    }
                    .padding(.top, 30)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            // MARK: Moving up when clicked
            .offset(y: showWalkThroughScreens ? -size.height : 0)
            
        })
        .ignoresSafeArea()
    }
    
}

#Preview {
    IntroView()
}


struct IntroHomeView: View {
    var body: some View {
        NavigationStack {
            Text("Home")
                .font(.title2)
        }
    }
}
