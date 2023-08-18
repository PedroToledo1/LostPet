//
//  MapManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 18/8/23.
//

import Foundation
import MapKit
import SwiftUI
import CoreLocation




final class locationManagerModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    // ubicacion princpipal para muestra
    @Published var locationLive = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 2209394, longitude: 230239324) , span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    //para marcador
    //@Published var markers: [Markers]
    //location manager
    var locationsManagers: CLLocationManager?
    //@Binding var image = UIImage()
    
    
    override init() {
            self.locationLive = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))
            //self.markers = []
            super.init()
            self.checkIfLocationServiceIsEnabled()
        }
        

    //chequea que tengas permisos y si no lo pide
    func checkIfLocationServiceIsEnable() {
        
            if CLLocationManager.locationServicesEnabled() {
            locationsManagers = CLLocationManager()
            locationsManagers!.delegate = self
        }else{
            print("Ubicacion no habilitada")
        }
        
    }
    
       private func checkIfLocationServiceIsEnabled(){
            
           guard locationsManagers != nil else {return}
            
            switch locationsManagers?.authorizationStatus {
            case .notDetermined:
                locationsManagers?.requestWhenInUseAuthorization()
            case .restricted:
                print("no puede usarse la ubicacion")
            case .denied:
                print("error")
            case .authorizedAlways, .authorizedWhenInUse:
                locationLive = MKCoordinateRegion(center: (locationsManagers?.location!.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            case .none:
                break
            @unknown default:
                break
            
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manger: CLLocationManager){
        checkIfLocationServiceIsEnabled()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationLive.center = locations.last!.coordinate
    }
    
    func createMarker(imagen: UIImage) {
       // let newMarker = Markers(titleKey: "Nuevo Marcador", date: Date.now, image: imagen/*image: image*/, coordinate: ((locationsManagers?.location!.coordinate)!), mapAnnotation: MapAnnotation(coordinate: ((locationsManagers?.location!.coordinate)!)){CustomAnnotationView()})
            
         //       markers.append(newMarker)
         //   print(markers)
            }
    }


