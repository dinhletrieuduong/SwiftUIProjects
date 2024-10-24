//
//  NewAPIFormatText.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 24/10/24.
//

import SwiftUI

struct DemoNewAPIFormatText: View {
    @State var amount: Decimal = 0.0

    var body: some View {
        ScrollView {
            VStack {

                // Default the currency to match the users locale,
                // or fall back to a certain if we can't figure out the locale
                Text(amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                // Displays "$0.00"

                // We can ensure our text to only ever display a certain type
                // of currency by using the following line (instead of the one above)
                Text(amount, format: .currency(code: "GBP"))
                // Displays ￡0.00 (no matter what locale you have choosen)

                // Accepting a number as input to a text field
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))

                Text(amount, format: .currency(code: "GBP"))
                TextField("Amount", value: $amount, format: .number.precision(.fractionLength(2)))
                    .keyboardType(.decimalPad)

                Text(Date.now, format: .dateTime.day().month().year())
                // Oct 7, 2023

                Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                // Oct 7, 2023

                Text(Date.now.formatted(date: .long, time: .omitted))
                // October 7, 2023

                Text(Date.now.formatted(date: .complete, time: .omitted))
                // Saturday, October 7, 2023

                Text(Date.now.formatted(date: .numeric, time: .omitted))
                // 10/7/2023

                Text(Date.now.formatted(date: .omitted, time: .complete))
                // 6:53:39 PM CDT

                Text(Date.now.formatted(date: .omitted, time: .standard))
                // 6:53:39 PM

                Text(Date.now.formatted(date: .omitted, time: .shortened))
                // 6:53 PM

                Text(Date.now.formatted(.dateTime.dayOfYear()))
                // 280

                Text(Date.now.formatted(.dateTime.era()))
                // AD

                Text(Date.now.formatted(.dateTime.quarter()))
                // Q4

                Text(Date.now.formatted(.dateTime.week()))
                // 40

                Text(Date.now.formatted(.dateTime.weekday()))
                // Sat

                Text(Date.now.formatted(.dateTime.year(.twoDigits)))
                // 23

                Text(Date.now.formatted(.dateTime.month(.narrow)))
                // O (this is an O for October, not a zero)

                Text(Date.now.formatted(.dateTime.hour(.twoDigits(amPM: .wide))))
                // 06 PM
            }
            .padding()
        }
    }
}

#Preview {
    DemoNewAPIFormatText()
}
