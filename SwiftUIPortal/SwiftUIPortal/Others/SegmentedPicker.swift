//
//  SegmentedPicker.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 24/02/2024.
//

import SwiftUI

struct SegmentedPicker<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
    @Binding var selection: SelectionValue?
    
    @Binding var items: [SelectionValue]
    
    private var selectionColor: Color = .blue
    
    private var content: (SelectionValue) -> Content
    
    @Namespace private var pickerTransition
    
    init(
        selection: Binding<SelectionValue?>,
        items: Binding<[SelectionValue]>,
        selectionColor: Color = .blue,
        @ViewBuilder content: @escaping (SelectionValue) -> Content
    ) {
        _selection = selection
        _items = items
        self.selectionColor = selectionColor
        self.content = content
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 6) {
                    ForEach(items, id:\.self) { item in
                        let selected = selection == item
                        
                        ZStack {
                            if selected {
                                Capsule()
                                    .foregroundStyle(selected ? selectionColor : .clear)
                                    .animationEffect(isSelected: selected, id: "picker", in: pickerTransition)
                                
                                content(item).id(item)
                                    .pickerTextStyle(isSelected: selected, selectionColor: selectionColor)
                            }
                            else {
                                Capsule()
                                    .foregroundStyle(.clear)
                                content(item).id(item)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .lineLimit(1)
                                    .clipShape(Capsule())
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selection = item
                            }
                        }
                        .onChange(of: selection) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                proxy.scrollTo(selection)
                            }
                        }
                    }
                    .onAppear {
                        if selection == nil, let first = items.first {
                            selection = first
                        }
                    }
                }
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct PickerStyle: ViewModifier {
    var isSelected = true
    var selectionColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(isSelected ? .white : .black)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .lineLimit(1)
            .clipShape(Capsule())
    }
}

extension View {
    func pickerTextStyle(isSelected: Bool, selectionColor: Color = .blue) -> some View {
        modifier(PickerStyle(isSelected: isSelected, selectionColor: selectionColor))
    }
}

struct AnimationEffect: ViewModifier {
    var isSelected = true
    var id: String
    var namespace: Namespace.ID
    
    func body(content: Content) -> some View {
        if isSelected {
            content.matchedGeometryEffect(id: id, in: namespace)
        } else {
            content
        }
    }
}

extension View {
    func animationEffect(isSelected: Bool, id: String, in namespace: Namespace.ID) -> some View {
        modifier(AnimationEffect(isSelected: isSelected, id: id, namespace: namespace))
    }
}

struct Book: Identifiable, Hashable {
    var id: UUID { UUID() }
    var title: String
    var author: String
}

struct SegmentedPickerDemoView: View {
    @State var books = [
        Book(title: "Atomic Habits", author: "James Clear"),
        Book(title: "Start With Why", author: "Simon Sinek"),
        Book(title: "Think Like A Monk", author: "Jay Shetty"),
        Book(title: "Limitless", author: "Jim Kwik")
    ]
    @State var selectedBook: Book?
    
    
    var body: some View {
        VStack {
            SegmentedPicker(
                selection: $selectedBook,
                items: $books,
                selectionColor: .cyan
            ) { book in
                HStack {
                    Text(book.title)
                    Image(systemName: "book.pages.fill")
                }
            }
            
            if let selectedBook {
                HStack {
                    Text("\(selectedBook.title) by ")
                    +
                    Text("\(selectedBook.author)")
                        .bold()
                        .foregroundStyle(.cyan)
                }.padding()
            }
        }
    }
}

#Preview {
    SegmentedPickerDemoView()
}
