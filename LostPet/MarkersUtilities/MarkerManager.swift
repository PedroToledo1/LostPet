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

struct Markers: Codable, Equatable, Identifiable {
    var id: Int
    let markerID: String
    let date: Date?
    let photourl: String?
    let coordinates: GeoPoint?
    
    enum CodingKeys: String, CodingKey {
        case id
        case markerID
        case date
        case photourl
        case coordinates
    }
//    static func ==(lhs: Markers, rhs: Markers) -> Bool {
//        return lhs.markerID == rhs.markerID
//    }
//    init(id: Int, markerID: String, date: Date?, photourl: String?, coordinates: GeoPoint?) {
//        self.id = id
//        self.markerID = markerID
//        self.date = date
//        self.photourl = photourl
//        self.coordinates = coordinates
//    }
}

final class MarkerManager: NSObject, ObservableObject, Identifiable, CLLocationManagerDelegate {
    
    @Published var loc = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    var a: Int = 0
    
    static let shared = MarkerManager()
    
    
    private let markerCollection = Firestore.firestore().collection("markers")
    
    private let storage = Storage.storage().reference()
    
    private func markerDocument(markerID: String) -> DocumentReference {
        markerCollection.document(markerID)
    }
    //: MARK: subir marcador
    func uploadMarker(markerId: Markers) async throws{
        try markerDocument(markerID: markerId.markerID).setData(from: markerId, merge: false)
    }
    
//    func getAllMarker() async throws -> [Markers]{
//       let snapshot = try await markerCollection.getDocuments()
//        var markers: [Markers] = []
//        for document in snapshot.documents{
//            let marker = try document.data(as: Markers.self)
//            markers.append(marker)
//        }
//        print("llego hasta aca")
//        return markers
//    }
    func getAllMarker() {
        Firestore.firestore().collection("markers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                }
            }
        }
    }
    
    private var imagesReference: StorageReference {
        storage.child("markers")
    }
    //: MARK: codigo para upload la foto y tener el path
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
    //: MARK: guardado y uploaded
    func saveMarkerImage(item: PhotosPickerItem) {
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            print("savemarker image parte 1")
            let (path, name) = try await MarkerManager.shared.saveImage(data: data)
            print("success")
            print(path)
            print(name)
            try await createMarker()
            func createMarker() async throws{
                print("entro a create marker")
                requestAllowOnceLocationPermission()
                let nuevoMark = Markers(id: a, markerID: (UUID().uuidString), date: Date(), photourl: path, coordinates: GeoPoint(latitude: loc.center.latitude, longitude: loc.center.longitude))
                try await uploadMarker(markerId: nuevoMark)
                a=a+1
               print(nuevoMark)
            }
        }
    }
    //: MARK: CODIGO DE UBICACION
    let locationManager = CLLocationManager()
    override init(){
        super.init()
        locationManager.delegate = self
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else{
            return
        }
        DispatchQueue.main.async {
            self.loc = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    func requestAllowOnceLocationPermission(){
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
