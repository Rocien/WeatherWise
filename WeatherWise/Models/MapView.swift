//
//  MapView.swift
//  WeatherWise
//
//  Created by Rocien Nkunga on 04/12/2024.
//

import MapKit // importing swift Mapkit
import SwiftUI


struct MapView: UIViewRepresentable {
    var cityName: String
    @State private var region = MKCoordinateRegion()

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        geocodeCityName(cityName, mapView: mapView)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // here should be empty as no updates needed for now
    }

    private func geocodeCityName(_ cityName: String, mapView: MKMapView) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let coordinate = location.coordinate
                let region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
                mapView.setRegion(region, animated: true)
            } else {
                print("Error geocoding city: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
