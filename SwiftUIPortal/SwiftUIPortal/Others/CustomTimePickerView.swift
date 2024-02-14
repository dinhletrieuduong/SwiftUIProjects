//
//  CustomTimePickerView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI


struct DatePickerView: View {
    
    @State private var selectedDate = Date()
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let start = Date()
        let end = DateComponents(year: 2024, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return start...calendar.date(from: end)!
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            
            DatePicker("Select a date", selection: $selectedDate, in: dateRange)
                .datePickerStyle(GraphicalDatePickerStyle())
            //            .datePickerStyle(WheelDatePickerStyle())
            
            
            CustomTimePickerView()
            
            Spacer()
        }
    }
}


struct CustomTimePickerView: View {
    
    @StateObject var dateModel = DateViewModel()
    
    var body: some View {
        ZStack {
            Text(dateModel.selectedDate, style: .time)
                .font(.largeTitle)
                .fontWeight(.bold)
                .onTapGesture {
                    withAnimation(.spring()) {
                        dateModel.setTime()
                        dateModel.showPicker.toggle()
                    }
                }
            
            if dateModel.showPicker {
                // Picker View
                VStack(spacing: 0) {
                    HStack(spacing: 18) {
                        Spacer()
                        
                        HStack(spacing: 0) {
                            Text("\(dateModel.hour < 10 ? "0" : "")\(dateModel.hour):")
                                .font(.largeTitle)
                                .fontWeight(dateModel.changeToMin ? .light : .bold)
                                .onTapGesture {
                                    dateModel.angle = Double(dateModel.hour * 30)
                                    dateModel.changeToMin = false
                                }
                            
                            Text("\(dateModel.minutes < 10 ? "0" : "")\(dateModel.minutes)")
                                .font(.largeTitle)
                                .fontWeight(dateModel.changeToMin ? .bold : .light)
                                .onTapGesture {
                                    dateModel.angle = Double(dateModel.minutes * 6)
                                    dateModel.changeToMin = true
                                }
                        }
                        
                        VStack(spacing: 8) {
                            Text("AM")
                                .font(.title2)
                                .fontWeight(dateModel.symbol == "AM" ? .bold : .light)
                                .onTapGesture {
                                    dateModel.symbol = "AM"
                                }
                            Text("PM")
                                .font(.title2)
                                .fontWeight(dateModel.symbol == "PM" ? .bold : .light)
                                .onTapGesture {
                                    dateModel.symbol = "PM"
                                }
                        }
                        .frame(width: 50)
                    }
                    .padding()
                    .foregroundColor(.black)
                    
                    // Cicular Slider
                    TimeSlider()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            dateModel.generateTime()
                        }, label: {
                            Text("Save")
                                .fontWeight(.bold)
                        })
                    }
                    .padding()
                    
                }
                // Max Width
                .frame(width: 300) // getWidth() - 120)
                .background(Color.primary)
                .cornerRadius(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.primary.opacity(0.3).ignoresSafeArea().onTapGesture {
                    withAnimation(.spring()) {
                        dateModel.showPicker.toggle()
                        dateModel.changeToMin = false
                    }
                })
                .environmentObject(dateModel)
            }
        }
    }
}

struct TimeSlider: View {
    @EnvironmentObject var dateModel: DateViewModel
    var body: some View {
        GeometryReader { reader in
            ZStack {
                // Time Slider
                let width = reader.frame(in: .global).width/2
                
                // Knob or Cirrcle
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40, alignment: .center)
                    .offset(x: width - 50)
                    .rotationEffect(.init(degrees: dateModel.angle))
                    .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnded(value:)))
                    .rotationEffect(.init(degrees: -90))
                
                ForEach(1...12, id: \.self) { i in
                    VStack {
                        Text("\(dateModel.changeToMin ? i * 5 : i)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .rotationEffect(Angle(degrees: Double(-i) * 30))
                    }
                    .offset(y: -width + 50)
                    .rotationEffect(Angle(degrees: Double(i) * 30))
                }
                
                // Arrow
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10, alignment: .center)
                    .overlay(Rectangle()
                        .fill(Color.blue)
                        .frame(width: 2, height: width/2, alignment: .center),
                             alignment: .bottom)
                    .rotationEffect(.init(degrees: dateModel.angle))
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            
        }
        .frame(height: 300)
    }
    
    func onChanged(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        // circle or knob size is 40
        let radians = atan2(vector.dy - 20, vector.dx - 20)
        var angle = radians * 180 / .pi
        if angle < 0 {
            angle = 360 + angle
        }
        
        dateModel.angle = Double(angle)
        
        // Disabling for minutes
        if !dateModel.changeToMin {
            // Rounding up the value
            let roundValue = 30 * Int(round(dateModel.angle/30))
            dateModel.angle = Double(roundValue)
            
        } else {
            // Updating minutes
            let progress = dateModel.angle / 360
            dateModel.minutes = Int(progress * 60)
        }
    }
    
    func onEnded(value: DragGesture.Value) {
        if !dateModel.changeToMin {
            dateModel.hour = Int(dateModel.angle/30)
            // Updating picker to minutes
            withAnimation {
                dateModel.angle = Double(dateModel.minutes * 6)
                dateModel.changeToMin = true
            }
        }
        else {
            withAnimation {
                
            }
        }
        
    }
}

extension View {
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    func getHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}

class DateViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var showPicker = false
    
    @Published var hour: Int = 12
    @Published var minutes: Int = 0
    
    // Switching between hours and minutes
    @Published var changeToMin = false
    @Published var symbol = "AM" // AM or PM
    
    // Angle
    @Published var angle: Double = 0
    
    func generateTime() {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        let correctHourValue = symbol == "AM" ? hour : (hour + 12)
        let date = format.date(from: "\(correctHourValue):\(minutes <= 10 ? "0" : "")\(minutes)")
        selectedDate = date!
        withAnimation {
            showPicker.toggle()
            changeToMin = false
        }
    }
    
    func setTime() {
        let calendar = Calendar.current
        hour = calendar.component(.hour, from: selectedDate)
        symbol = hour <= 12 ? "AM" : "PM"
        hour = hour == 0 ? 12 : hour
        hour = hour <= hour ? hour : hour - 12
        
        minutes = calendar.component(.minute, from: selectedDate)
        
        angle = Double(hour * 30)
    }
}
