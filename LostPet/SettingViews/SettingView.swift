//
//  SettingView.swift
//  LostPet
//
//  Created by Pedro Toledo on 15/8/23.
//

import SwiftUI

@MainActor
final class SettingViewModel: ObservableObject{
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    func delete()async throws{
        try await AuthenticationManager.shared.delete()
    }
}
struct SettingView: View {
    
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showsignInView: Bool
    
    var body: some View {
        List {
            Button(action: {
                Task{
                    do{
                        try viewModel.logOut()
                        showsignInView = true
                        print("se logout exitoso")
                    } catch {
                        print("error log out")
                    }
                }
            }, label: {Text("Log Out")})
            Section("Delete Account"){
                Button(role: .destructive, action: {
                    Task{
                        do{
                            try await viewModel.delete()
                            showsignInView = true
                            print("se elimino la cuenta")
                            
                        } catch {
                            print("error delete")
                        }
                    }
                }, label: {
                    Text("DELETE ACCOUNT")
                })
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingView(showsignInView: .constant(false))
        }
    }
}
