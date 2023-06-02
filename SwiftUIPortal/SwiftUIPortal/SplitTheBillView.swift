//
//  SplitTheBillView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI

struct SplitTheBillView: View {
    @State private var totalCost = ""
    @State private var people = 4
    @State private var tipIndex = 0
    @State private var shippingFee = ""
    
    let tipPercentages: [Double] = [0, 5, 10, 15]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter an amount")) {
                    TextField("Amount", text: $totalCost)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Select a tip amount (%)")) {
                    Picker("Tip percentage", selection: $tipIndex) {
                        ForEach(0..<tipPercentages.count, id: \.self) { index in
                            Text("\(tipPercentages[index], specifier: "%.2f")%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Enter the shipping fee")) {
                    TextField("Shipping Fee", text: $shippingFee)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("How many people?")) {
                    Picker("Number of people", selection: $people) {
                        ForEach(1..<30, id: \.self) { index in
                            Text("\(index) people")
                        }
                    }
                }
                
                Section(header: Text("Total per person")) {
                    Text("$ \(calculateTotal(), specifier: "%.2f")")
                }
                
            }
            .navigationTitle("Split The Bill")
        }
    }
    
    func calculateTotal() -> Double {
        let tip = Double(tipPercentages[tipIndex])
        let orderTotal: Double = Double(totalCost) ?? 0
        let shippingFee: Double = Double(shippingFee) ?? 0
        
        let finalAmount = orderTotal/100 * tip + orderTotal + shippingFee
        return finalAmount / Double(people)
    }
}
