//
//  ProfileView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/21/23.
//

import SwiftUI


@MainActor
final class ProfileViewModel: ObservableObject{
    
    @Published private(set) var user: DBUser?  = nil
    
    func loadCurrentUser() async throws {
        let authDataResutl = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResutl.uid)
    }
}

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List{
            if let user = viewModel.user {
                Text("UserId: \(user.userId)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("Is anonymour: \(isAnonymous.description.capitalized)")
                }
                
                
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem{
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
                
                
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView(showSignInView: .constant(false))
        }
    }
}
