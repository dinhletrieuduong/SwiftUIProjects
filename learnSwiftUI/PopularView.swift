//
//  PopularView.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 17/11/2021.
//

import SwiftUI

struct PopularityView: View {
    
    var programmingLanguages = ProgrammingLanguage.programmingLanguages
    var frameworks = Framework.frameworks
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Popular Programming Languages")
            CircleGraph(for: programmingLanguages)
            Text("Popular Frameworks")
            CircleGraph(for: frameworks)
        }
    }
}

struct ProgrammingLanguage: GraphItem {
    var amount: Double
    var color: Color
    var name: String
    
    static let programmingLanguages = [
        ProgrammingLanguage(amount: 200, color: Color.orange, name: "Kotlin"),
        ProgrammingLanguage(amount: 100, color: Color.blue, name: "Dart"),
        ProgrammingLanguage(amount: 1000, color: Color.purple, name: "Java"),
        ProgrammingLanguage(amount: 400, color: Color.green, name: "Swift")
    ]
}

struct Framework: GraphItem {
    var amount: Double
    var color: Color
    var name: String
    
    static let frameworks = [
        Framework(amount: 100_000, color: .pink, name: "UIKit"),
        Framework(amount: 10_500, color: .yellow, name: "Combine"),
        Framework(amount: 50_000, color: .orange, name: "SwiftUI"),
        Framework(amount: 1000, color: .black, name: "Core Data")
    ]
}


protocol GraphItem {
    var amount: Double { get }
    var color: Color { get }
    var name: String { get }
}

extension GraphItem {
    var id: String { UUID().uuidString }
}

struct CircleGraph: View {
    
    var graphItems: [GraphItem]
    
    @State private var selectedIndex: Int? = nil
    
    init(for items: [GraphItem]) {
        self.graphItems = items
    }
    
    var body: some View {
        
        let startAndEnds = getStartAndEnd() ?? []
        
        return ZStack {
            Circle()
                .trim(from: 0.0, to: 1.0)
                .stroke(Color.gray, lineWidth: 20)
                .frame(width: 200, height: 200)
                .animation(.spring())
            
            ZStack {
                ForEach(0..<startAndEnds.count) { index in
                    Circle()
                        .trim(from: CGFloat(startAndEnds[index].0), to: CGFloat(startAndEnds[index].1))
                        .stroke(graphItems[index].color, lineWidth: index == selectedIndex ? 30 : 20)
                        .frame(width: 200, height: 200)
                        .animation(.spring())
                        .onTapGesture {
                            toggleExpansion(for: index)
                        }
                }
            }
            
            if selectedIndex != nil {
                VStack {
                    Text(graphItems[selectedIndex!].name)
                        .font(.largeTitle)
                    Text("\(Int(graphItems[selectedIndex!].amount))")
                        .font(.subheadline)
                }
            }
        }
    }
    
    private func toggleExpansion(for index: Int) {
        
        if selectedIndex == nil || selectedIndex != index {
            selectedIndex = index
        }
        else {
            selectedIndex = nil
        }
    }
    
    
    private func getStartAndEnd() -> [(Double, Double)]? {
        
        guard !graphItems.isEmpty else { return nil }
        
        let total = graphItems.map { $0.amount }.reduce(0, +)
        
        let percentages = graphItems.map { ($0.amount / total) }
        
        var startAndEnd = [(Double, Double)]()
        
        var start = 0.0
        var end = percentages.first!
        
        for index in 0..<percentages.count {
            startAndEnd.append((start, end))
            
            if index < percentages.count - 1 {
                start = end
                end = end + percentages[index + 1]
            }
        }
        return startAndEnd
    }
}

struct CircleGraph_Previews: PreviewProvider {
    static var previews: some View {
        CircleGraph(for: Framework.frameworks)
    }
}
