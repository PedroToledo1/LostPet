//
//  MarkerManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 17/8/23.
//

import Foundation

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
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

func createNewMarkerManager(){
    
}
