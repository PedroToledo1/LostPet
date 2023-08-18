//
//  MarkerStructs.swift
//  LostPet
//
//  Created by Pedro Toledo on 17/8/23.
//

import Foundation
//import FirebaseStorage
import CoreLocation
import MapKit
import SwiftUI

/*
 class MarkerServices{
 
 static let instances = MarkerServices()
 
 private var marcadores_Ref = Firestore.firestore().collection("markers")
 
 func uploadMarker(userID: String, image: UIImage, coordinates: CLLocationCoordinate2D, date: Date, handler: @escaping(_ success: Bool)-> ()){
 
 //create new marker
 let document = marcadores_Ref.document()
 let markerID = document.documentID
 
 //upload image for the marker
 
 }
 }
 
 func uploadMarkerImage(markerID: String, image: UIImage, handler: @escaping (_ success: Bool)-> ()){
 
 }
 
 private func getMarkerImage(markerID: String) -> StorageReference {
 let markerPath = "marker/\(markerID)/1"
 let storagePath = marcadores_Ref.reference(withPath: markerPath)
 reutrn
 }
 
 private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
 
 
 var compression: CGFloat = 1.0 // Loops down by 0.05
 let maxFileSize: Int = 240 * 240 // Maximum file size that we want to save
 let maxCompression: CGFloat = 0.05 // Maximum compression we ever allow
 
 // Get image data
 guard var originalData = image.jpegData(compressionQuality: compression) else {
 print("Error getting data from image")
 handler(false)
 return
 }
 
 
 // Check maximum file size
 while (originalData.count > maxFileSize) && (compression > maxCompression) {
 compression -= 0.05
 if let compressedData = image.jpegData(compressionQuality: compression) {
 originalData = compressedData
 }
 print(compression)
 }
 
 
 // Get image data
 guard let finalData = image.jpegData(compressionQuality: compression) else {
 print("Error getting data from image")
 handler(false)
 return
 }
 
 // Get photo metadata
 let metadata = StorageMetadata()
 metadata.contentType = "image/jpeg"
 
 // Save data to path
 path.putData(finalData, metadata: metadata) { (_, error) in
 
 if let error = error {
 //Error
 print("Error uploading image. \(error)")
 handler(false)
 return
 } else {
 //Success
 print("Success uploading image")
 handler(true)
 return
 }
 
 }
 
 }
 
 
 private func downloadImage(path: StorageReference, handler: @escaping (_ image: UIImage?) -> ()) {
 
 if let cachedImage = imageCache.object(forKey: path) {
 print("Image found in cache")
 handler(cachedImage)
 return
 } else {
 path.getData(maxSize: 27 * 1024 * 1024) { (returnedImageData, error) in
 
 if let data = returnedImageData, let image = UIImage(data: data) {
 // Success getting image data
 imageCache.setObject(image, forKey: path)
 handler(image)
 return
 } else {
 print("Error getting data from path for image: \(error)")
 handler(nil)
 return
 }
 
 }
 }
 
 }
 */
