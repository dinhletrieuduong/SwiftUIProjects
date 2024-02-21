//
//  CustomMapView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI
import MapKit

struct CustomMapDemoView: View {
    @State private var camera: MapCameraPosition = .region(.init(center: .applePark, span: .initialSpan))
    
    @State private var mapSpan: MKCoordinateSpan = .initialSpan
    @State private var coordinate: CLLocationCoordinate2D = .applePark
    @State private var annotationTitle: String = ""
    
    @State private var updateCamera: Bool = false
    @State private var displayTitle: Bool = false
    
    var body: some View {
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

struct CustomMapView: View {
    @State var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 49.246292, longitude: -123.116226), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var markerPlaces = [
        Marker(location: "Vancouver Aquarium", coordinate: .init(latitude: 49.300796, longitude: -123.130929)),
        .init(location: "Space Centre", coordinate: .init(latitude: 49.276224, longitude: -123.144443))
    ]
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: markerPlaces) { place in
                MapMarker(coordinate: place.coordinate, tint: .red)
            }
            .edgesIgnoringSafeArea(.all)
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
