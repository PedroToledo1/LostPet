//
//  AuthenticationManager.swift
//  LostPet
//
//  Created by Pedro Toledo on 15/8/23.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.photoUrl = user.photoURL?.absoluteString
        self.email = user.email
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init(){}
    
    func getAuthenticatedUser() throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        return AuthDataResultModel(user: user)
    }
    
    func getProvider() throws{
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        for provider in providerData{
            print(provider.providerID)
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func delete() async throws{
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.delete()
    }
}
// MARK: Sign In SSO
extension AuthenticationManager {
    
    @discardableResult
    func signInwithGoogle(tokens: GoogleSignInResultModel)async throws -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signInwithCredential(credential: credential)
    }
    @discardableResult
    func signInwithApple(tokens: SignInWithAppleResult)async throws -> AuthDataResultModel{
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokens.token , rawNonce: tokens.nonce)
        return try await signInwithCredential(credential: credential)
    }
    func signInwithCredential(credential: AuthCredential)async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
