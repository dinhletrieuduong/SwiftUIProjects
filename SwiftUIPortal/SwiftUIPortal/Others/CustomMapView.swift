//
//  CustomMapView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI
import MapKit

enum MapTab: String, CaseIterable {
    case people
    case devices
    case items
    case me
    
    var symbol: String {
        switch self {
            case .people:
                "figure.2.arms.open"
            case .devices:
                "macbook.and.iphone"
            case .items:
                "circle.grid.2x2.fill"
            case .me:
                "person.circle.fill"
        }
    }
}

struct CustomMapDemoView: View {
    @State private var camera: MapCameraPosition = .region(.init(center: .applePark, span: .initialSpan))
    
    @State private var mapSpan: MKCoordinateSpan = .initialSpan
    @State private var coordinate: CLLocationCoordinate2D = .applePark
    @State private var annotationTitle: String = ""
    
    @State private var updateCamera: Bool = false
    @State private var displayTitle: Bool = false
    
    @State private var showSheet: Bool = false
    @State private var activeTab: MapTab = .devices
    @State private var ignoreTabBar: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapReader { proxy in
                Map(position: $camera) {
                    Annotation(displayTitle ? annotationTitle : "", coordinate: coordinate) {
                        DraggablePin(proxy: proxy, coordinate: $coordinate) { coordinate in
                            findCoordinateName()
                            
                            guard updateCamera else { return }
                            let newRegion = MKCoordinateRegion(center: coordinate, span: mapSpan)
                            
                            withAnimation(.smooth) {
                                camera = .region(newRegion)
                            }
                        }
                    }
                }
                .onMapCameraChange(frequency: .continuous) { ctx in
                    mapSpan = ctx.region.span
                }
                .safeAreaInset(edge: .bottom, content: {
                    HStack(spacing: 0) {
                        Toggle("Update Camera", isOn: $updateCamera)
                            .frame(width: 180)
                        
                        Spacer(minLength: 0)
                        
                        Toggle("Display Title", isOn: $displayTitle)
                            .frame(width: 150)
                    }
                    .textScale(.secondary)
                    .padding(15)
                    .background(.ultraThinMaterial)
                })
                .onAppear {
                    findCoordinateName()
                }
            }
            
            TabBar()
                .frame(height: 49)
                .background(.regularMaterial)
        }
        .task {
            showSheet = true
        }
        .sheet(isPresented: $showSheet, content: {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(activeTab.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Toggle("Ignore Tab Bar", isOn: $ignoreTabBar)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .presentationDetents([.height(60), .medium, .large])
            .presentationCornerRadius(25)
            .presentationBackground(.regularMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .interactiveDismissDisabled()
            .bottomMaskForSheet(mask: !ignoreTabBar)
            
        })
        
    }
    
    private func findCoordinateName() {
        annotationTitle = ""
        Task {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let geoDecoder = CLGeocoder()
            if let name = try? await geoDecoder.reverseGeocodeLocation(location).first?.name {
                annotationTitle = name
            }
        }
    }
    
    @ViewBuilder
    func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(MapTab.allCases, id: \.rawValue) { tab in
                Button(action: {
                    activeTab = tab
                }, label: {
                    VStack(spacing: 2) {
                        Image(systemName: tab.symbol)
                            .font(.title2)
                        
                        Text(tab.rawValue)
                            .font(.caption2)
                    }
                    .foregroundStyle(activeTab == tab ? Color.accentColor : .gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                })
                .buttonStyle(.plain)
            }
        }
    }
}

struct DraggablePin: View {
    var tint: Color = .red
    var proxy: MapProxy
    
    @Binding var coordinate: CLLocationCoordinate2D
    
    @State private var isActive: Bool = false
    @State private var translation: CGSize = .zero
    
    var onCoordinateChanged: (CLLocationCoordinate2D) -> Void
    
    var body: some View {
        GeometryReader {
            let frame = $0.frame(in: .global)
            
            Image(systemName: "mappin")
                .font(.title)
                .foregroundStyle(tint.gradient)
                .animation(.snappy, body: { content in
                    content
                        .scaleEffect(isActive ? 1.3 : 1, anchor: .bottom)
                })
                .frame(width: frame.width, height: frame.height)
                .onChange(of: isActive, initial: false) { oldValue, newValue in
                    let position = CGPoint(x: frame.midX, y: frame.midY)
                    
                    /// Converting position into location coordinate using map proxy
                    if let coordinate = proxy.convert(position, from: .global), !newValue {
                        /// Updating coordinate based on translation and resetting translation to zero
                        self.coordinate = coordinate
                        translation = .zero
                        onCoordinateChanged(coordinate)
                    }
                    
                }
            
        }
        .frame(width: 30, height: 30)
        .contentShape(.rect)
        .offset(translation)
        .gesture(
            LongPressGesture(minimumDuration: 0.15)
                .onEnded({
                    isActive = $0
                })
                .simultaneously(with:
                                    DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        if isActive {
                            translation = value.translation
                        }
                    })
                        .onEnded({ value in
                            if isActive {
                                isActive = false
                            }
                        })
                               )
        )
    }
}

#Preview(body: {
    CustomMapDemoView()
})

private extension View {
    @ViewBuilder
    func bottomMaskForSheet(mask: Bool = true, _ height: CGFloat = 49) -> some View {
        self
            .background(SheetRootViewFinder(mask: mask, height: height))
    }
}

private struct SheetRootViewFinder: UIViewRepresentable {
    var mask: Bool
    var height: CGFloat
    
    func makeUIView(context: Context) -> UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            guard !context.coordinator.isMarked else { return }
            
            if let rootView = uiView.viewBeforeWindow, let window = rootView.window {
                let safeArea = window.safeAreaInsets
                rootView.frame = .init(origin: .zero, size: .init(width: window.frame.width, height: window.frame.height - (mask ? (height + safeArea.bottom): 0)))
                
                rootView.clipsToBounds = true
                for view in rootView.subviews {
                    /// Removing Shadow
                    view.layer.shadowColor = UIColor.clear.cgColor
                    
                    if view.layer.animationKeys() != nil {
                        if let cornerRadiusView = view.allSubviews.first(where: { $0.layer.animationKeys()?.contains("cornerRadius") ?? false }) {
                            cornerRadiusView.layer.maskedCorners = []
                        }
                    }
                }
                
            }
        }
    }
    
}


struct Marker: Identifiable {
    let id = UUID()
    var location: String
    var coordinate: CLLocationCoordinate2D
}

extension MKCoordinateSpan {
    static var initialSpan: MKCoordinateSpan {
        return .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
}

extension CLLocationCoordinate2D {
    static var applePark: CLLocationCoordinate2D {
        return .init(latitude: 37.334606, longitude: -122.009102)
    }
}
