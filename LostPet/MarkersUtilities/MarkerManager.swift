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
    
    func getMarker(markerID: String) async throws -> Markers {
        try await markerDocument(markerID: markerID).getDocument(as: Markers.self)
    }
    //: MARK: subir marcador
    func uploadMarker(markerId: Markers) async throws{
        
        try markerDocument(markerID: markerId.markerID).setData(from: markerId, merge: false)
    }

    func getMarket(markerID: String) async throws -> Markers{
        try await markerDocument(markerID: markerID).getDocument(as: Markers.self)
    }
    
    func getAllMarker() async throws -> [Markers] {
        try await markerCollection.GetDocuments(as: Markers.self)
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
extension Query {
    
//    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
//        try await getDocumentsWithSnapshot(as: type).products
//    }
    func GetDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable{
        let snapshot = try await self.getDocuments()
        print("get document query")
        
        return try snapshot.documents.map({document in
            try document.data(as: T.self)
        })
    }
    
//    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
//        let snapshot = try await self.getDocuments()
//
//        let products = try snapshot.documents.map({ document in
//            try document.data(as: T.self)
//        })
//
//        return (products, snapshot.documents.last)
//    }
//
//    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
//        guard let lastDocument else { return self }
//        return self.start(afterDocument: lastDocument)
//    }
//
//    func aggregateCount() async throws -> Int {
//        let snapshot = try await self.count.getAggregation(source: .server)
//        return Int(truncating: snapshot.count)
//    }
//
//    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T : Decodable {
//        let publisher = PassthroughSubject<[T], Error>()
//
//        let listener = self.addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//
//            let products: [T] = documents.compactMap({ try? $0.data(as: T.self) })
//            publisher.send(products)
//        }
//
//        return (publisher.eraseToAnyPublisher(), listener)
//    }
    
}


