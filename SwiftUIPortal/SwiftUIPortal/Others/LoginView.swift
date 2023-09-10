//
//  LoginScene.swift
//  learn
//
//  Created by LAP14482 on 25/07/2021.
//

import SwiftUI
import Foundation

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    var _center: NotificationCenter
    init(center: NotificationCenter = .default) {
        _center = center
        //4. Tell the notification center to listen to the system keyboardWillShow and keyboardWillHide notification
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            withAnimation {
                currentHeight = keyboardSize.height
            }
        }
    }
    @objc func keyBoardWillHide(notification: Notification) {
        withAnimation {
            currentHeight = 0
        }
    }
}

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

let storedUsername = "Myusername"
let storedPassword = "Mypassword"

struct WelcomeText : View {
    var body : some View {
        return Text("Welcome!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}
struct UserImage : View {
    var body: some View {
        return Image("userImage")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(25)
            .padding(.bottom, 50)
        
    }
}
struct LoginButtonContent : View {
    var body: some View {
        return Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}
struct UsernameTextField : View {
    @Binding var username: String
    var body: some View {
        return
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.secondary)
                    .padding(.leading)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(lightGreyColor)
                    .foregroundColor(Color.black)
            }
            .padding([.top, .bottom, .horizontal], 5)
            .background(lightGreyColor)
            .cornerRadius(10)
    }
}
struct PasswordSecureField : View {
    @Binding var password: String
    var body: some View {
        return
            HStack {
                Image("keyImage")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
            }
            .padding([.top, .bottom, .horizontal], 5)
            .background(lightGreyColor)
            .cornerRadius(10)
    }
}

struct RememberForgotView: View {
    var body: some View {
        HStack {
            Image(systemName: "circle")
                .imageScale(.large)
                .foregroundColor(.gray)
            Text("Remember me")
                .font(.footnote)
                .foregroundColor(.gray)
            Spacer()
            Text("Forgot password")
                .font(.footnote)
                .foregroundColor(.blue)
                .bold()
        }
    }
}

struct LoginView : View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var authenticationDidFail: Bool = true
    @State var authenticationDidSucceed: Bool = false
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        ZStack {
            VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10, content:{
                WelcomeText()
                UserImage()
                UsernameTextField(username: $username)
                PasswordSecureField(password: $password)
                RememberForgotView()
                if authenticationDidFail {
                    Text("Information not correct. Try again.")
                        .padding([.top, .bottom], 5)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    if self.username == storedUsername && self.password == storedPassword {
                        self.authenticationDidSucceed = true
                        self.authenticationDidFail = false
                    } else {
                        self.authenticationDidFail = true
                        self.authenticationDidSucceed = false
                    }
                    
                }) {
                    LoginButtonContent()
                }
                
                Spacer()
            })
            .padding()
            if authenticationDidSucceed {
                Text("Login succeeded!")
                    .font(.headline)
                    .frame(width: 250, height: 80)
                    .background(Color.green)
                    .cornerRadius(20.0)
                    .foregroundColor(.white)
                    .animation(Animation.default)
            }
        }
        .offset(y: -keyboardResponder.currentHeight * 0.9)
//        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
}



