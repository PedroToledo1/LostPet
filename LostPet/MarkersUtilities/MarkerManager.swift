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
import CoreLocationUI


struct marcadoresFinal{
    let markerId: String
    let date: Date
    let photourl: String
    let coordinates: GeoPoint
}


struct MarkerManagerData: Codable {
    let markerID: String
    let date: Date
    let photomarker: String
    let coordinates: GeoPoint
    
    init(marker: marcadoresFinal) {
        self.markerID = marker.markerId
        self.photomarker = marker.photourl
        self.date = Date()
        self.coordinates = marker.coordinates
    }

    enum CodingKeys: String, CodingKey {
        case markerID = "markerid"
        case photomarker = "photomarker"
        case date = "date"
        case coordinates = "coordinates"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.markerID, forKey: .markerID)
        try container.encodeIfPresent(self.photomarker, forKey: .photomarker)
        try container.encodeIfPresent(self.date, forKey: .date)
        try container.encodeIfPresent(self.coordinates, forKey: .coordinates)
        
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.markerID = try container.decode(String.self, forKey: .markerID)
        self.photomarker = try container.decodeIfPresent(String.self, forKey: .photomarker)!
        self.date = try container.decodeIfPresent(Date.self, forKey: .date)!
        self.coordinates = try container.decodeIfPresent(GeoPoint.self, forKey: .coordinates)!
    }
}

final class StorageManager: NSObject, ObservableObject, Identifiable, CLLocationManagerDelegate {
    
    
    @Published var loc = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    
    let markerCollection = Firestore.firestore().collection("markers")
    
    static let shared = StorageManager()
    override init(){
        super.init()
        locationManager.delegate = self
    }
    private let storage = Storage.storage().reference()
    //: MARK: Funciones para el guardado de imagenes y obtencion del path
    
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
            let (path, name) = try await StorageManager.shared.saveImage(data: data)
            print("success")
            print(path)
            print(name)
            requestAllowOnceLocationPermission()
            let marcadorsito = marcadoresFinal(markerId: UUID().uuidString, date: Date(), photourl: path, coordinates: GeoPoint(latitude: (loc.center.latitude), longitude: (loc.center.longitude)))
            let uno = MarkerManagerData(marker: marcadorsito)
            try await newMarker(marcador: uno)
            print(uno)
            
        }
    }
    
    
    //: MARK: agregar marcadores
    
    private func markerDocument(markerID: String) -> DocumentReference {
        markerCollection.document(markerID)
    }
    func newMarker(marcador: MarkerManagerData)async throws{
        try markerCollection.document(marcador.markerID).setData(from: marcador, merge: false)
    }
    
    //: MARK: marcador especifico
    func getmarkerImage(marcador: String) async throws -> MarkerManagerData {
        try await markerDocument(markerID: marcador).getDocument(as: MarkerManagerData.self)
    }
    
    
    
    //: MARK: geolocalizacion
    
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
