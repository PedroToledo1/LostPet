//
//  UserLocationManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 19/8/23.
//

import Foundation
import MapKit


//: MARK: localizacion para el maps cuando se inicia
final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    
    var locationManager: CLLocationManager!
    
    func checkIfLocationServicesIsEnable(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            checkLocationAuthorization()
            locationManager!.delegate = self
        }else{
            print("La ubicaion gato, dale activala")
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else {return}
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("This app will need location permission to upload the markers. if not you will only be able too see the ones that already exist")
        case .denied:
            print("This app will need location permission to upload the markers. if not you will only be able too see the ones that already exist")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        @unknown default:
            break
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        region.center = locations.last!.coordinate
        print("la ubicacion \(region.center)")
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
