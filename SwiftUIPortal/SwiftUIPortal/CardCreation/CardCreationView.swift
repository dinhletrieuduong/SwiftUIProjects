//
//  CardCreationView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 03/09/2023.
//

import SwiftUI
import Combine

struct CardCreationView: View {
    
    // MARK: View Properties
    @FocusState private var activeTF: ActiveKeyboardField!
    @State private var cardNumber: String = ""
    @State private var cardHolderName: String = ""
    @State private var cvvCode: String = ""
    @State private var expiredDate: String = ""
    
    @EnvironmentObject var router: Router
    
    var body: some View {
//        NavigationStack {
            VStack {
                /// Header view
                HStack {
                    Button(action: {
                        router.navigateBack()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundStyle(.black)
                    })
                    
                    Text("Add Card")
                        .font(.title3)
                        .padding(.leading, 10)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}, label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                    })
                }
                
                CardView()
                
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Label("Add Card", systemImage: "lock")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.blue.gradient)
                        }
                }
                /// Disabling action, until all details have been completely filled
                .disableWithOpacity(cardNumber.count != 19 || expiredDate.count != 5 || cvvCode.count != 3 || cardHolderName.isEmpty)
            }
            .padding()
            .toolbar(.hidden, for: .navigationBar)
            /// Keyboard change button
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    /// No button needed for the last item
                    if activeTF != .cardHolderName {
                        Button("Next") {
                            switch activeTF {
                                case .cardNumber:
                                    activeTF = .expirationDate
                                case .cardHolderName:
                                    break
                                case .expirationDate:
                                    activeTF = .cvv
                                case .cvv:
                                    activeTF = .cardHolderName
                                case .none:
                                    break
                            }
                        }
                        .tint(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
//        }
    }
    
    
    @ViewBuilder
    func CardView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.linearGradient(colors: [
                Color("CardGradient1"),
                Color("CardGradient2")
                ], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            /// Card Detail
            VStack(spacing: 10, content: {
                HStack {
                    TextField("XXXX XXXX XXXX XXXX", text: .init(get: {
                        cardNumber
                    }, set: { value in
                        cardNumber = ""
                        
                        // BUG: not running when user edit on iOS 17.0
                        
                        /// Inserting space for every 4 digits
                        let startIndex = value.startIndex
                        for index in 0..<value.count {
                            let strIndex = value.index(startIndex, offsetBy: index)
                            cardNumber += String(value[strIndex])
                            
                            if (index + 1) % 5 == 0 && value[strIndex] != " " {
                                cardNumber.insert(" ", at: strIndex)
                            }
                        }
                        
                        /// Removing empty space when going back
                        if value.last == " " {
                            cardNumber.removeLast()
                            
                        }
                        
                        /// Limitting to 16 digits
                        /// Including with 3 spaces
                        cardNumber = String(cardNumber.prefix(19))
                    }))
                        .font(.title3)
                        .keyboardType(.numberPad)
                        .focused($activeTF, equals: .cardNumber)
                    
                    Spacer(minLength: 0)
                    
                    Image("visaIcon")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                
                HStack(spacing: 12, content: {
                    TextField("MM/YY", text: .init(get: {
                        expiredDate
                    }, set: { value in
                        expiredDate = value
                        /// Inserting a splash in the third string position to differentiate between month and year
                        if value.count == 3 && !value.contains("/") {
                            let startIndex = value.startIndex
                            let thirdPos = value.index(startIndex, offsetBy: 2)
                            expiredDate.insert("/", at: thirdPos)
                        }
                        
                        /// Removing splash when going back
                        if value.last == "/" {
                            expiredDate.removeLast()
                        }
                        
                        /// Limiting string included with on splash
                        expiredDate = String(expiredDate.prefix(5))
                    }))
                        .keyboardType(.numberPad)
                        .focused($activeTF, equals: .expirationDate)
                    
                    Spacer(minLength: 0)
                    
                    TextField("CVV", text: .init(get: {
                        cvvCode
                    }, set: { value in
                        cvvCode = value
                        /// Simply limit to max 3 digits
                        cvvCode = String(cvvCode.prefix(3))
                    }))
                        .keyboardType(.numberPad)
                        .frame(width: 35)
                        .focused($activeTF, equals: .cvv)
                    
                    Image(systemName: "questionmark.circle.fill")
                })
                .padding(.top, 15)
                
                Spacer(minLength: 0)
                
                TextField("CARD HOLDER", text: $cardHolderName)
                    .focused($activeTF, equals: .cardHolderName)
                    .submitLabel(.done)
                
                
            })
            .padding(20)
            .environment(\.colorScheme, .dark)
            .tint(.white)
        }
        .frame(height: 200)
        .padding(.top, 35)
    }
    
}

#Preview {
    CardCreationView()
}
