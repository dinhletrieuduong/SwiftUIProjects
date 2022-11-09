//
//  Switch.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 16/11/2021.
//

import Foundation
import SwiftUI

struct Switch: View {
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            Capsule().frame(width: 66, height: 40)
                .foregroundColor(isOn ? .green : .gray)
                .onTapGesture {
                    isOn.toggle()
                }
            
            Circle()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
                .offset(x: isOn ? 12 : -12)
                .animation(.easeInOut)
        }
    }
}

struct ProfileView: View {
    @State private var showFavLanguage = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Image")
                Spacer()
                Switch(isOn: $showFavLanguage)
            }
            .padding()
            
            Spacer()
            
            Image(systemName: "ladybug")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundColor(.purple)
                .scaleEffect(showFavLanguage ? 1 : 0)
            
            Spacer()
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
