//
//  ProfileViews.swift
//  LostPet
//
//  Created by Pedro Toledo on 16/8/23.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws{
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(UserID: authDataResult.uid)
    }
}


struct ProfileViews: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showsignInView: Bool
    var body: some View {
        List{
            if let user = viewModel.user {
                Text("UserID: \(user.userID)")
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                NavigationLink{
                    SettingView(showsignInView: $showsignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

struct ProfileViews_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ProfileViews(showsignInView: .constant(false))
        }
    }
}
