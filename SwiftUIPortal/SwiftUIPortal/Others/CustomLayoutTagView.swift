//
//  CustomLayoutTagView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 07/02/2024.
//

import SwiftUI

struct CustomLayoutTagView: View {
    
    @State var tags: [Tag] = rawTags.compactMap { tag -> Tag? in
        .init(name: tag)
    }
    
    @State var alignmentValue: Int = 1
    
    
    var body: some View {
        VStack(spacing: 10) {
            TagView(alignment: alignmentValue == 0 ? .leading : alignmentValue == 1 ? .center : .trailing, spacing: 10) {
                ForEach($tags) { $tag in
                    Toggle(tag.name, isOn: $tag.isSelected)
                        .toggleStyle(.button)
                        .buttonStyle(.bordered)
                        .background(tag.isSelected ? .clear : .gray)
                        .tint(tag.isSelected ? .green : .white)
                        .clipShape(.rect(cornerRadius: 10))
                }
            }
            
            HashtagView(tags: hashtags) { tag in
                print(tag)
            }
            Spacer()
        }
        .padding(15)
        .background(.yellow)
    }
}

struct Tag: Identifiable {
    var id: UUID = .init()
    var name: String
    var isSelected: Bool = false
}

var rawTags: [String] = [
    "SwiftUI", "Xcode", "WWDC 24", "iOS 17", "iPad Pro", "iPhone 15", "MacBook Pro M1 14inches", "Swift 5.8", "SwiftUI 4", "Xcode 15", "MacBook Air"
]

struct TagView: Layout {
    var alignment: Alignment = .leading
    var spacing: CGFloat = 10
    
    init(alignment: Alignment, spacing: CGFloat) {
        self.alignment = alignment
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return .init(width: proposal.width ?? 0, height: proposal.height ?? 0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        let maxWidth = bounds.width
        
        var row: ([LayoutSubviews.Element], Double) = ([], 0.0)
        var rows: [([LayoutSubviews.Element], Double)] = []
        
        for view in subviews {
            let viewSize = view.sizeThatFits(proposal)
            
            if (origin.x + viewSize.width + spacing) > maxWidth {
                row.1 = (bounds.maxX - origin.x + bounds.minX + spacing)
                rows.append(row)
                row.0.removeAll()
                
                origin.x = bounds.origin.x
                
                row.0.append(view)
                origin.x += (viewSize.width + spacing)
            } else {
                row.0.append(view)
                origin.x += (viewSize.width + spacing)
            }
        }
        
        if !row.0.isEmpty {
            row.1 = (bounds.maxX - origin.x + bounds.minX + spacing)
            rows.append(row)
        }
        
        origin = bounds.origin
        
        for row in rows {
            origin.x = (alignment == .leading ? bounds.minX : (alignment == .trailing ? row.1 : row.1/2))
            
            for view in row.0 {
                let viewSize = view.sizeThatFits(proposal)
                
                view.place(at: origin, proposal: proposal)
                
                origin.x += (viewSize.width + spacing)
            }
            
            let maxHeight = row.0.compactMap { view -> CGFloat? in
                return view.sizeThatFits(proposal).height
            }.max() ?? 0
            
            origin.y += maxHeight + spacing
        }
        
    }
}

let hashtags = ["#trending", "#viral", "#instagram", "#love", "#explorepage", "#explore", "#instagood", "#fashion", "#follow", "#tiktok", "#like", "#likeforlikes", "#followforfollowback", "#photography", "#india", "#trend", "#instadaily", "#memes", "#music", "#style", "#trendingnow", "#reels", "#foryou", "#likes", "#photooftheday", "#model", "#beautiful", "#bollywood", "#bhfyp", "#insta", "adfadf", "#swiftui", "#iosdeveloper", "#swift", "#ios", "#developer", "#xcode", "#programming", "#coding", "#iosdev", "#iosdevelopment", "#programmer", "#coder", "#swiftlang", "#developerlife", "#softwaredeveloper", "#apple", "#swiftdeveloper", "#appdeveloper", "#appdevelopment", "#swiftdev", "#code", "#developers", "#programmers", "#devlife", "#daysofcode", "#dev", "#codinglife", "#ui", "#mobiledevelopment", "#tech"
]

// MARK: HashtagView
struct HashtagView: View {
    
    var tags: [String]
    var viewBackground: Color = Color.yellow
    var cloudBackground: Color = Color.gray
    var font: Font = Font.body
    var action: (String) -> ()
    
    @State private var viewHeight = CGFloat.zero
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    ScrollView(.vertical) {
                        self.generateHashtagViews(g: geometry)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity)
        .background(viewBackground)
    }
    
    private func generateHashtagViews(g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id: \.self) { tag in
                self.HashtagTextView(text: tag)
                    .padding([.leading, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if(abs(width - d.width) > g.size.width){
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if tag == self.tags.last! {
                            height = 0
                        }
                        return result
                    })
            }
        }.background(getViewHeight($viewHeight))
        
    }
    
    @ViewBuilder
    private func HashtagTextView(text: String) -> some View {
        Button {
            action(text)
        } label: {
            HStack(alignment: .top) {
                Text(text)
                    .font(font)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .bold()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(cloudBackground)
            .cornerRadius(30)
        }
    }
    
    private func getViewHeight(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geo -> Color in
            let rect = geo.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

#Preview {
    CustomLayoutTagView()
}
