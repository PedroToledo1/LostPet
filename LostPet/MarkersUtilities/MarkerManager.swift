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

final class StorageManager: ObservableObject {
    
    static let shared = StorageManager()
    init(){}
    private let storage = Storage.storage().reference()
    
    func createNewMarkerManager(){
    }
    
    func saveImage(data: Data) async throws -> (path: String, name: String){
        let meta = StorageMetadata()
        meta.contentType = "image/png"
        let path = "\(UUID().uuidString).png"
        let returnMetaData = try await storage.child(path).putDataAsync(data, metadata: meta)
        
        guard let ReturnPath = returnMetaData.path, let ReturnName = returnMetaData.name else {
            throw URLError(.badURL)
            
        }
        return(ReturnPath, ReturnName)
    }
    
    func saveMarkerImage(item: PhotosPickerItem) {
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let (path, name) = try await StorageManager.shared.saveImage(data: data)
            print("success")
            print(path)
            print(name)
        }
    }
}
