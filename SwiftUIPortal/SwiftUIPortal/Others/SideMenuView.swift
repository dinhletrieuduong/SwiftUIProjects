//
//  SideMenuView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 24/01/2024.
//

import SwiftUI

struct SideMenuViewContents: View {
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                SideMenuTopView()
                VStack {
                    Text("Side Menu")
                        .foregroundColor(.white)
                }.frame( maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(.gray)
        }
    }
    
    func SideMenuTopView() -> some View {
        VStack {
            HStack {
                Button(action: {
                    presentSideMenu.toggle()
                }, label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                })
                .frame(width: 34, height: 34)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 40)
        .padding(.top, 40)
        .padding(.bottom, 30)
    }
}

struct SideMenuView<RenderView: View>: View {
    @Binding var isShowing: Bool
    var direction: Edge
    @ViewBuilder  var content: RenderView
    
    var body: some View {
        ZStack(alignment: .leading) {
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .transition(.move(edge: direction))
                    .background(
                        Color.white
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
}

struct SideMenuContentView: View {
    @State var presentSideMenu = false
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    HStack {
                        Button {
                            presentSideMenu.toggle()
                        } label: {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.black)
                        }
                        .frame(width: 24, height: 24)
                        .padding(.leading, 30)
                        
                        Spacer()
                    }
                }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .zIndex(1)
                    .shadow(radius: 0.3)
                , alignment: .top)
            .background(Color.gray.opacity(0.8))
            
            SideMenu()
        }
        
        .frame(maxWidth: .infinity)
        
    }
    
    
    @ViewBuilder
    private func SideMenu() -> some View {
        SideMenuView(isShowing: $presentSideMenu, direction: .leading) {
            SideMenuViewContents(presentSideMenu: $presentSideMenu)
                .frame(width: 300)
        }
    }
    
}

#Preview(body: {
    SideMenuContentView()
})
