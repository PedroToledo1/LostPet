//
//  MapView.swift
//  LostPet
//
//  Created by Pedro Toledo on 18/8/23.
//
import SwiftUI
import MapKit
import FirebaseStorage
import FirebaseFirestore


final class markersviewModel: ObservableObject{
    @Published private(set) var markers: [Markers] = []
    
    func getAllMarkers() async throws{
        print("previoooooooooooooooooo")
        self.markers = try await MarkerManager.shared.getAllMarker()
        print("funciona la funcion nnnnnnnnnnnnnnnnnnnnnnn")
    }
    
}

struct MapView: View {
    @StateObject private var mark = markersviewModel()
    
    @StateObject private var userLocation = LocationViewModel()
    
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $userLocation.region,
                showsUserLocation: true,
                annotationItems: mark.markers){marker in
                MapAnnotation<markersmapview>(coordinate: CLLocationCoordinate2D(latitude: marker.coordinates!.latitude, longitude: marker.coordinates!.longitude)){
                    markersmapview()
                }
            }
            .ignoresSafeArea()
            .accentColor(Color(.systemGreen))
            .onAppear{
                userLocation.checkIfLocationServicesIsEnable()
                print($userLocation.region)
            }
            
        }
    }
}
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
