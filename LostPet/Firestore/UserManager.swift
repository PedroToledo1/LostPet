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
    
    init(auth: AuthDataResultModel){
        self.userID = auth.uid
        self.email = auth.email
        self.photourl = auth.photoUrl
        self.dateCreated = Date()
    }
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email = "email"
        case photourl = "photo_url"
        case dateCreated = "date_created"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userID, forKey: .userID)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photourl, forKey: .photourl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photourl = try container.decodeIfPresent(String.self, forKey: .photourl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
    }
    
    
}

final class UserManager {
    static let shared = UserManager()
    private init(){}
    
    private let  userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userID: String)->DocumentReference{
        userCollection.document(userID)
    }
    func createNewUser(user: DBUser) async throws {
        try userDocument(userID: user.userID).setData(from: user, merge: false)
    }
    
    func getUser(UserID: String) async throws -> DBUser{
        try await userDocument(userID: UserID).getDocument(as: DBUser.self)
    }
    
    
}
