//
//  MapView.swift
//  LostPet
//
//  Created by Pedro Toledo on 18/8/23.
//
import SwiftUI
import MapKit


struct MapView: View {
    @StateObject private var userLocation = LocationViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .ignoresSafeArea()
            .onAppear{
                userLocation.
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
