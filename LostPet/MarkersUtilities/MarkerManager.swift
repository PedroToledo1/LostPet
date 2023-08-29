//
//  MarkerManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 17/8/23.
//
import SwiftUI
import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseStorageCombineSwift
import FirebaseFirestoreSwift
import PhotosUI
import MapKit
import GeoFireUtils
import CoreLocation
import CoreLocationUI



struct MarkerArray: Codable {
    let marcadores: [Markers]
}

struct Markers: Identifiable, Codable, Equatable {
    var id = String()
    let date: Date
    let photourl: String?
    let coordinates: GeoPoint?
    
    enum CodingKeys: String, CodingKey {
        case date
        case photourl
        case coordinates
    }
}

final class MarkerManager: NSObject, ObservableObject, Identifiable, CLLocationManagerDelegate {
    
    @Published var loc = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    static let shared = MarkerManager()
    override init() { }
    
    private let markerCollection = Firestore.firestore().collection("markers")
    private let storage = Storage.storage().reference()
    
    private func markerDocument(markerID: String) -> DocumentReference {
        markerCollection.document(markerID)
    }
    
    func markerProduct(marker: Markers) async throws {
        try markerDocument(markerID: marker.id).setData(from: marker, merge: false)
    }
    
    func getProduct(markerID: String) async throws -> Markers {
        try await markerDocument(markerID: markerID).getDocument(as: Markers.self)
    }
    
    
    private var imagesReference: StorageReference {
        storage.child("markers")
    }
    
    func saveImage(data: Data) async throws -> (path: String, name: String){
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        print("save image paso 1")
        let path = "\(UUID().uuidString).png"
        print(path)
        let returnMetaData = try await imagesReference.child(path).putDataAsync(data, metadata: meta)
        print("save image parte 2")
        
        guard let ReturnPath = returnMetaData.path, let ReturnName = returnMetaData.name else {
            throw URLError(.cancelled)
            
        }
        print(ReturnPath)
        print(ReturnName)
        return(ReturnPath, ReturnName)
    }
    
    func saveMarkerImage(item: PhotosPickerItem) {
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            print("savemarker image parte 1")
            let (path, name) = try await MarkerManager.shared.saveImage(data: data)
            print("success")
            print(path)
            print(name)
            //requestAllowOnceLocationPermission()
            func nuevoMarcador(){
                let nuevoMark = Markers(date: Date(), photourl: path, coordinates: GeoPoint(latitude: loc.center.latitude, longitude: loc.center.longitude))
                let uno = try? MarkerArray(from: nuevoMark as! Decoder)
            }
        }
    }
    
    let locationManager = CLLocationManager()
    
    func requestAllowOnceLocationPermission(){
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            return
        }
        DispatchQueue.main.async {
            self.loc = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
//final class StorageManager: NSObject, ObservableObject, Identifiable, CLLocationManagerDelegate {
//
//
//    @Published var loc = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
//
//
//    let markerCollection = Firestore.firestore().collection("markers")
//
//    static let shared = StorageManager()
//    override init(){
//        super.init()
//        locationManager.delegate = self
//
//    }
//    private let storage = Storage.storage().reference()
//    //: MARK: Funciones para el guardado de imagenes y obtencion del path
//
//    private var imagesReference: StorageReference {
//        storage.child("markers")
//    }
//
//    func saveImage(data: Data) async throws -> (path: String, name: String){
//        let meta = StorageMetadata()
//        meta.contentType = "image/png"
//        print("save image paso 1")
//        let path = "\(UUID().uuidString).png"
//        print(path)
//        let returnMetaData = try await imagesReference.child(path).putDataAsync(data, metadata: meta)
//        print("save image parte 2")
//
//        guard let ReturnPath = returnMetaData.path, let ReturnName = returnMetaData.name else {
//            throw URLError(.cancelled)
//
//        }
//        print(ReturnPath)
//        print(ReturnName)
//        return(ReturnPath, ReturnName)
//    }
//
//    func saveMarkerImage(item: PhotosPickerItem) {
//        Task {
//            guard let data = try await item.loadTransferable(type: Data.self) else { return }
//            print("savemarker image parte 1")
//            let (path, name) = try await StorageManager.shared.saveImage(data: data)
//            print("success")
//            print(path)
//            print(name)
//            requestAllowOnceLocationPermission()
//            let marcadorsito = marcadoresFinal(markerId: UUID().uuidString, date: Date(), photourl: path, coordinates: GeoPoint(latitude: (loc.center.latitude), longitude: (loc.center.longitude)))
//            let uno = try marcadoresFinal(from: marcadorsito)
//            try await newMarker(marcador: uno)
//            print(uno)
//
//        }
//    }
//
//
//    //: MARK: agregar marcadores
//
//    private func markerDocument(markerID: String) -> DocumentReference {
//        markerCollection.document(markerID)
//    }
//    func newMarker(marcador: marcadoresFinal)async throws{
//        try markerCollection.document(marcador.markerId).setData(from: marcador, merge: false)
//    }
//
//    //: MARK: marcador especifico
//    func getmarkerImage(marcador: String) async throws -> marcadoresFinal {
//        try await markerDocument(markerID: marcador).getDocument(as: Decodable.self)
//    }
//
//
//
//    //: MARK: geolocalizacion
//
//    let locationManager = CLLocationManager()
//
//    func requestAllowOnceLocationPermission(){
//        locationManager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let latestLocation = locations.first else {
//            return
//        }
//        DispatchQueue.main.async {
//            self.loc = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//        }
//    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//
//    //:MARK: download marcadores
//
//    func getAllMarkers() async  throws -> [marcadoresFinal]{
//        let snapshot = try await markerCollection.getDocuments()
//
//        var markers: [marcadoresFinal] = []
//
//        for document in snapshot.documents{
//            let marker = try document.data(as: marcadoresFinal.self)
//            markers.append(marker)
//        }
//        return markers
//    }
//}
