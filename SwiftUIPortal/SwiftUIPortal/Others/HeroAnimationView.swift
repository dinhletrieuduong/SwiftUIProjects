//
//  HeroAnimationView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 26/10/24.
//

import SwiftUI

struct DemoHeroAnimationView: View {
    @Namespace private var animation

    @State private var selectedItem: Item? = nil

    private let items: [Item] = [
        Item(id: 1, color: .red, size: .init(width: 100, height: 100)),
        Item(id: 2, color: .green, size: .init(width: 100, height: 100)),
        Item(id: 3, color: .blue, size: .init(width: 100, height: 100)),
        Item(id: 4, color: .purple, size: .init(width: 100, height: 100)),
        Item(id: 5, color: .indigo, size: .init(width: 100, height: 100)),
        Item(id: 6, color: .yellow, size: .init(width: 100, height: 100)),
        Item(id: 7, color: .brown, size: .init(width: 100, height: 100)),
        Item(id: 8, color: .orange, size: .init(width: 100, height: 100)),
        Item(id: 9, color: .pink, size: .init(width: 100, height: 100))
    ]

    var body: some View {
        NavigationStack {
            VStack {
                if let selectedItem = selectedItem {
                    DetailView(item: selectedItem, animation: animation, onDismiss: {
                        withAnimation(.smooth(duration: 0.5)) {
                            self.selectedItem = nil
                        }
                    })
                }
                else {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(items) { item in
                            HStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(item.color)
                                    .frame(width: item.size.width, height: item.size.height)
                                    .matchedGeometryEffect(id: item.id, in: animation)

                                Text("\(Text("Rect \(item.id)").font(.system(size: 25)).foregroundColor(item.color))\nLorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae ...")
                                    .font(.system(size: 15))

                                Spacer()
                            }
                            .padding()
                            .onTapGesture {
                                withAnimation {
                                    selectedItem = item
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct DetailView: View {
    let item: Item
    var animation: Namespace.ID
    var onDismiss: () -> Void

    var body: some View {
        VStack {
            Rectangle()
                .fill(item.color)
                .frame(width: .infinity, height: 300)
                .matchedGeometryEffect(id: item.id, in: animation)
                .onTapGesture {
                    onDismiss()
                }

            ScrollView(.vertical, showsIndicators: false) {
                Text("\(Text("Rect \(item.id)").font(.system(size: 45)).foregroundColor(item.color))\nLorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit, tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit, quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam recusandae alias error harum maxime adipisci amet laborum. Perspiciatis minima nesciunt dolorem! Officiis iure rerum voluptates a cumque velit quibusdam sed amet tempora. Sit laborum ab, eius fugit doloribus tenetur fugiat, temporibus enim commodi iusto libero magni deleniti quod quam consequuntur! Commodi minima excepturi repudiandae velit hic maxime doloremque. Quaerat provident commodi consectetur veniam similique ad earum omnis ipsum saepe, voluptas, hic voluptates pariatur est explicabo fugiat, dolorum eligendi quam cupiditate excepturi mollitia maiores labore suscipit quas? Nulla, placeat. Voluptatem quaerat non architecto ab laudantium modi minima sunt esse temporibus sint culpa, recusandae aliquam numquam totam ratione voluptas quod exercitationem fuga. Possimus quis earum veniam quasi aliquam eligendi, placeat qui corporis!")
                    .padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
    }
}

private struct Item: Identifiable {
    let id: Int
    let color: Color
    let size: CGSize
}

#Preview(body: {
    DemoHeroAnimationView()
})
