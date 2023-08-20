//
//  MarkerManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 17/8/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseStorageCombineSwift
import FirebaseFirestoreSwift
//
//struct DBMarker {
//    let markerId: String
//    let userId: String
//    let photo_url: String
//    let coordinate: CLLocationCoordinate2D
//    let date_created : Date
//
//}
//
//final class markerManager{
//
//    func createNewMarker(marker_id: String){
//        var markerData: [String: Any] = [
//            "marker_id" : markerId
//        ]
//        Firestore.firestore().collection("markers").document(marker_id).setData(<#T##documentData: [String : Any]##[String : Any]#>, merge: false)
//    }
//}
//
//


struct MarkerManagerData {
    let uid: String
    let date: Date
    let photomarker: String
    
    init(marker: MarkerManagerData) {
        self.uid = marker.uid
        self.photomarker = marker.photomarker
        self.date = marker.date
    }
}
final class StorageManager{
    static let shared = StorageManager()
    private init(){}
    private let storage = Storage.storage().reference()
    
    func createNewMarkerManager(){
    }
    
    func saveImage(data: Data) async throws -> (path: String, name: String){
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let path = "\(UUID().uuidString).jpeg"
        let returnMetaData = try await storage.child(path).putDataAsync(data, metadata: meta)
        
        guard let ReturnPath = returnMetaData.path, let ReturnName = returnMetaData.name else {
            throw URLError(.badURL)
            
        }
        return(ReturnPath, ReturnName)
    }
}
