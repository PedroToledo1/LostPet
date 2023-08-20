//
//  UserLocationManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 19/8/23.
//

import Foundation
import MapKit

final class LocationViewModel: ObservableObject{
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnable(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        }else{
            print("La ubicaion gato, dale activala")
        }
    }
}
