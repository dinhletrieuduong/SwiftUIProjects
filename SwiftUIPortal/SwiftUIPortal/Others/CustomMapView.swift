//
//  CustomMapView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI
import MapKit

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


struct DatePickerView: View {
    
    @State private var selectedDate = Date()
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let start = Date()
        let end = DateComponents(year: 2023, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return start...calendar.date(from: end)!
    }()
    
    var body: some View {
        DatePicker("Select a date", selection: $selectedDate, in: dateRange)
            .datePickerStyle(GraphicalDatePickerStyle())
        //            .datePickerStyle(WheelDatePickerStyle())
    }
}
