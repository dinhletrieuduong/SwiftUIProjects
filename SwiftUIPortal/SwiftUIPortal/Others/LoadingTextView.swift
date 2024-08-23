//
//  LoadingTextView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 23/8/24.
//

import SwiftUI

struct LoadingTextView: View {
    @State var start = false
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3).ignoresSafeArea()
            VStack{
                ZStack{
                    Text("Loading...").font(.largeTitle.bold())
                        .foregroundStyle(.black)

                    Text("Loading...").font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .frame(width: 200, height: 50)
                        .background(.black )
                        .mask {
                            Circle()
                                .frame(width: 40, height: 40)
                                .offset(x: start ? -60 : 60)
                        }
                    Circle().stroke(.black,lineWidth: 5)
                        .frame(width: 40, height: 40)
                        .offset(x: start ? -60 : 60)
                }
                .onAppear{
                    withAnimation(.easeInOut(duration: 1)
                        .repeatForever(autoreverses: true)){
                            start = true
                        }
                }
                .padding(.top,40)
                Spacer()
            }


        }


    }
}

#Preview {
    LoadingTextView()
}

