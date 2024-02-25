//
//  CustomSegmentControl.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 24/02/2024.
//

import SwiftUI

struct CustomSegmentControlDemoView: View {
    
    @State var selectedIndex1 = 0
    @State var selectedIndex2 = 0
    @State var selectedIndex3 = 0
    
    let options1: [SegmentControlItem] = [
        SegmentControlItem(name: "Car"),
        SegmentControlItem(name: "Bike")
    ]
    
    let options2: [SegmentControlItem] = [
        SegmentControlItem(name: "Car", iconString: "car.fill"),
        SegmentControlItem(name: "Bike", iconString: "bicycle"),
        SegmentControlItem(name: "Bus", iconString: "bus"),
    ]
    
    let options3: [SegmentControlItem] = [
        SegmentControlItem(iconString: "car.fill"),
        SegmentControlItem(iconString: "bicycle"),
        SegmentControlItem(iconString: "bus"),
        SegmentControlItem(iconString: "airplane"),
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            CustomSegmentControl(
                selectedIndex: $selectedIndex1,
                options: options1
            )
            
            CustomSegmentControl(
                selectedIndex: $selectedIndex2,
                options: options2
            )
            
            CustomSegmentControl(
                selectedIndex: $selectedIndex3,
                options: options3
            )
        }
        .padding()
    }
}

struct SegmentControlItem {
    var name: String? = nil
    var iconString: String? = nil
}

struct CustomSegmentControl: View{
    @Binding var selectedIndex: Int
    let options: [SegmentControlItem]
    
    public var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 6.0)
                    .foregroundColor(.white)
                    .cornerRadius(6.0)
                    .padding(4)
                    .frame(width: geo.size.width / CGFloat(options.count))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 1, y: 1)
                    .offset(x: geo.size.width / CGFloat(options.count) * CGFloat(selectedIndex), y: 0)
            }
            .frame(height: 40)
            
            HStack(spacing: 0) {
                ForEach((0..<options.count), id: \.self) { index in
                    HStack(spacing: 6) {
                        if let iconString = options[index].iconString {
                            Image(systemName: iconString)
                        }
                        if let name = options[index].name {
                            Text(name)
                        }
                    }
                    .font(.system(size: 16, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.00001))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.150)) {
                            selectedIndex = index
                        }
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 6.0)
                .fill(Color.black.opacity(0.05))
        )
    }
}

#Preview(body: {
    CustomSegmentControlDemoView()
})
