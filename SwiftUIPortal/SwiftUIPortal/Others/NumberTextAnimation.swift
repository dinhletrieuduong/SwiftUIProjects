//
//  NumberTextAnimation.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 14/01/2024.
//

import SwiftUI

struct NumberTextAnimation: View {
    @State var sum: Double = 0
    
    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.init(identifier: "en_US")
        return formatter
    }()
    
    
    var body: some View {
        ZStack {
            TextAnimatableValue(value: sum, formatter: formatter)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .monospacedDigit()
            
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1)) {
                            sum -= 1000
                        }
                    }, label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title.bold())
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1)) {
                            sum = 0
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title.bold())
                            .foregroundStyle(.black)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1)) {
                            sum += 1000
                        }
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title.bold())
                            .foregroundStyle(.black)
                    })
                }
            }
        }
            .padding(40)
    }
}

private struct TextAnimatableValue: View, Animatable {
    var value: Double
    var formatter: NumberFormatter
    
    var animatableData: Double {
        get { value }
        set {
            value = newValue
        }
    }
    
    var body: some View {
        Text(formatter.string(for: value) ?? "")
    }
}

#Preview {
    NumberTextAnimation()
}
