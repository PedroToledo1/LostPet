//
//  AuthView.swift
//  LostPet
//
//  Created by Pedro Toledo on 15/8/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import AuthenticationServices
import CryptoKit

struct SignInWithAppleButttonViewRepresentable:  UIViewRepresentable{
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}



@MainActor
final class AuthenticationViewModel: NSObject, ObservableObject{
    
    private var currentNonce: String?
    @Published var didSignInWithApple: Bool = false
    
    func signInGoogle() async throws{
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInwithGoogle(tokens: tokens)
        
    }
    func signInApple() async throws{
        startSignInWithAppleFlow()
    }
    
    
    func startSignInWithAppleFlow() {
        guard let topVC = Utilities.shared.topViewController() else {
            return
        }
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = topVC
      authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}


struct SignInWithAppleResult{
    let token: String
    let nonce: String
}

extension AuthenticationViewModel: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8),
            let nonce = currentNonce else{
            print("error en apple sign in")
            return
        }
        
        let tokens = SignInWithAppleResult(token: idTokenString, nonce: nonce)
        Task{
            do{
                try await AuthenticationManager.shared.signInwithApple(tokens: tokens)
                didSignInWithApple = true
            }catch{
                
            }
        }
    }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}


extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

struct AuthView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showsignInView: Bool
    
    var body: some View {
        VStack{
            NavigationLink{
                Text("exito")
            }label: {
                Text("login")
            }
            Button(action: {
                Task{
                    do{
                        try await viewModel.signInGoogle()
                        showsignInView = false
                    }catch{
                        print("error google")
                    }
                }
            }, label: {
                HStack{
                    Image(systemName: "globe")
                    Text("Continue with Google")
                }
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color(.sRGB, red: 223/225, green: 82/255, blue: 70/225, opacity: 1.0))
                .cornerRadius(10)
                .font(.system(size: 23, weight: .medium, design: .default))
                .foregroundColor(.white)
            })
            Button(action: {
                Task{
                    do{
                        try await viewModel.signInApple()
                        showsignInView = false
                    }catch{
                        print("error Apple")
                    }
                }
            }, label: {
                
                    
            })
            .onChange(of: viewModel.didSignInWithApple){ newValue in
                if newValue {
                    showsignInView = false
                }
                
            }
        }
        .padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(showsignInView: .constant(false))
    }
}
