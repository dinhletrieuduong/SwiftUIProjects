//
//  TabCategoryView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 03/02/2024.
//

import SwiftUI

struct TabCategoryView: View {
    var categories: [String]
    @State private var selectedCategory: Int = 0
    var action: (String) -> ()
    
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { geometry in
                ScrollView(.horizontal) {
                    VStack {
                        HStack(spacing: 10) {
                            ForEach(0..<categories.count, id: \.self) { i in
                                CategoryItem(isSelected: i == selectedCategory, title: categories[i])
                                    .onTapGesture {
                                        selectedCategory = i
                                        action(categories[i])
                                    }
                            }
                        }
                    }
                    .frame(width: geometry.size.width)
                }.scrollIndicators(.never)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct CategoryItem: View {
    var isSelected: Bool = false
    var title: String = "All"
    
    var body: some View {
        VStack(spacing: 1) {
            Text(title)
                .font(Font.custom("Tenor Sans", size: 23))
                .kerning(1)
                .multilineTextAlignment(.center)
                .foregroundColor( isSelected ? Color(.yellow) : Color.gray.opacity(0.9))
                .bold(isSelected)
            if isSelected {
                Rectangle()
                    .foregroundColor(Color(.yellow))
                    .frame(width: 5, height: 5)
                    .rotationEffect(Angle(degrees: 45))
            }
        }
    }
}

let categoriesData: [String] = ["All", "Royal Cannin", "Cat rang", "Ciao"]
struct TabCategoryViewDemo: View {

    @State private var selectedCategory: Int = 0
    
    var body: some View {
        VStack()  {
            VStack {
                HStack {
                    TabCategoryView(categories: categoriesData) { selected in
                        print("Selected Category : \(selected)")
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.black)
    }
}
#Preview {
    TabCategoryViewDemo()
}
