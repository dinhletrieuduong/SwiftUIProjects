//
//  TransparentBlurView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 26/06/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct TransparentBlurView: View {
    @State private var activePic: String = "Pic"
    @State private var blurType: BlurType = .freeStyle
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            
            ScrollView(.vertical) {
                VStack(spacing: 15) {
                    HeaderTransparentBlurView(removeAllFilters: true)
                        .blur(radius: 14, opaque: blurType == .clipped)
                        .padding([.horizontal, .top], -30)
                        .frame(height: 100 + safeArea.top)
                        .visualEffect { view, proxy in
                            view.offset(y: (proxy.bounds(of: .scrollView)?.minY ?? 0))
                        }
                    // Place it above all the Views
                        .zIndex(1000)
                    
                    VStack(alignment: .leading, spacing: 10, content: {
                        GeometryReader {
                            let size = $0.size
                            
                            Image(activePic)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius : 25))
                        }
                        .frame(height: 500)
                        
                        Text("Blur Type")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding(.top, 15)
                        
                        Picker("", selection: $blurType) {
                            ForEach(BlurType.allCases, id: \.self) { type in
                                Text(type.rawValue)
                                    .tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    })
                    .padding(15)
                    .padding(.bottom, 500)
                }
            }
            //        .scrollIndicators(.hidden)
        }
    }
}

enum BlurType: String, CaseIterable {
    case clipped = "Clipped"
    case freeStyle = "Free Style"
}

struct HeaderTransparentBlurView: UIViewRepresentable {
    var removeAllFilters: Bool = false
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return view
    }
    
//    func updateUIView(_ uiView: UIView, context: Context) {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let backdropLayer = uiView.layer.sublayers?.first {
                if removeAllFilters {
                    backdropLayer.filters = []
                } else {
                    // Remove all expect blur filters
                    backdropLayer.filters?.removeAll(where: { filter in
                        String(describing: filter) != "gaussianBlur"
                    })
                }
            }
        }
    }
}
