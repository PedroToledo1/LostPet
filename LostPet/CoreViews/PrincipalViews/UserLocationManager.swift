//
//  UserLocationManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 19/8/23.
//

import Foundation
import MapKit

final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
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
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
