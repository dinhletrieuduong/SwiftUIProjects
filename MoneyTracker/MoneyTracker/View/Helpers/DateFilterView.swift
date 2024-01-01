//
//  DateFilterView.swift
//  MoneyTracker
//
//  Created by Dinh Le Trieu Duong on 01/01/2024.
//

import SwiftUI

struct DateFilterView: View {
    @State var start: Date
    @State var end: Date
    
    var onSubmit: (Date, Date) -> Void
    var onClose: () -> Void
    var body: some View {
        VStack(spacing: 15, content: {
            DatePicker("Start Date", selection: $start, displayedComponents: [.date])
            
            DatePicker("End Date", selection: $end, displayedComponents: [.date])
            
            HStack(spacing: 15, content: {
                Button("Cancel") {
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(.red)
                
                Button("Filter") {
                    onSubmit(start, end)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 5))
                .tint(appTint)
            })
            .padding(.top, 10)
            
        })
        .padding(15)
        .background(.bar, in: .rect(cornerRadius: 10))
        .padding(.horizontal, 30)
    }
}
