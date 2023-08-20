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
    
    
    var body: some View {
        Map(coordinateRegion: $userLocation.region , showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemGreen))
            .onAppear{
                userLocation.checkIfLocationServicesIsEnable()
            }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
