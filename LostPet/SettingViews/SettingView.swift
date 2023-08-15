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
}
struct SettingView: View {
    
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showsignInView: Bool
    
    var body: some View {
        List {
            Button("Log Out"){
                Task{
                    do{
                        try viewModel.logOut()
                        showsignInView = false
                    } catch{
                        
                    }
                }
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
