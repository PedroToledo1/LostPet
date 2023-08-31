//
//  MapView.swift
//  LostPet
//
//  Created by Pedro Toledo on 18/8/23.
//
import SwiftUI
import MapKit

@MainActor
final class markersviewModel: ObservableObject{
    @Published private(set) var markers: [Markers] = []
    
    func getAllMarkers() async throws{
        self.markers = try await MarkerManager.shared.getAllMarkers()
    }
    
}


struct MapView: View {
    @StateObject private var userLocation = LocationViewModel()
    @StateObject private var mark = markersviewModel()
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $userLocation.region,
                showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemGreen))
            .onAppear{
                userLocation.checkIfLocationServicesIsEnable()
                print($userLocation.region)
            }
            .task {
                try? await mark.getAllMarkers()
                print("succes import markers")
                print([mark.markers])
                
            }
            
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
