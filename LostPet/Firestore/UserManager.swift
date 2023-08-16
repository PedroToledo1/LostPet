//
//  UserManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 16/8/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userID : String
    let email : String?
    let photourl : String?
    let dateCreated : Date?
}

final class UserManager {
    static let shared = UserManager()
    private init(){}
    
    private let  userCollection = Firestore.firestore().collection("users")
    private func userDocument(userID: String)->DocumentReference{
        userCollection.document(userID)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userID: user.userID).setData(from: user, merge: false, encoder: encoder)
    }
    
    func getUser(UserID: String) async throws -> DBUser{
        try await userDocument(userID: UserID).getDocument(as: DBUser.self, decoder: decoder)
    }
}
