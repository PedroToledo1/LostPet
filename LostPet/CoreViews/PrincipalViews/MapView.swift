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
}

struct MapView: View {
    //    @StateObject private var mark = MarkerManager()
    @ObservedObject var marcadores = MarkerManager()
    @StateObject private var userLocation = LocationViewModel()
    
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $userLocation.region,
                showsUserLocation: true,
                annotationItems: marcadores.markers){marker in
                MapAnnotation<markersmapview>(coordinate: CLLocationCoordinate2D(latitude: marker.coordinates!.latitude, longitude: marker.coordinates!.longitude)){
                    markersmapview(markers: marker)
                }
                //        Map(coordinateRegion: $userLocation.region,
                //            showsUserLocation: true)
            }
                .ignoresSafeArea()
                .accentColor(Color(.systemGreen))
                .onAppear{
                    Task{
                        userLocation.checkIfLocationServicesIsEnable()
                        try await marcadores.getAllMarker()
                                            print("succes import markers")
                        
                    }
                }

                
            
            
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
