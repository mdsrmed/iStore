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
    
    func togglePremiumStatus() {
        guard let user else { return }
//        let currentValue = user.isPremium ?? false
//        let updatedUser = DBUser(userId: user.userId, isAnonymous: user.isAnonymous,email: user.email,photoUrl: user.photoUrl,dateCreated: user.dateCreated,isPremium: !currentValue)
       let currentValue = user.isPremium ?? false
//        user.isPremium = !currentValue
        //let updatedUser = user.togglePremiumStatus()
        
//        user.togglePremiumStatus()
        Task {
            try await UserManager.shared.updataUserPremiumStatus(userId: user.userId,isPremium: !currentValue)
            self.user =  try await UserManager.shared.getUser(userId: user.userId)
        }
        
    }
    
    func addUserPreference(text: String){
        guard let user else { return }
        
        Task {
            try await UserManager.shared.addUserPreference(userId: user.userId,preference: text)
            self.user =  try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func removeUserPreference(text: String){
        guard let user else { return }
        
        Task {
            try await UserManager.shared.removeUserPreference(userId: user.userId,preference: text)
            self.user =  try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func addFavoriteMovie(){
        guard let user else { return }
        let movie = Movie(id: "1", title: "Forest Gump", isPopular: true)
        
        Task {
            try await UserManager.shared.addFavoriteMovie(userId: user.userId,movie: movie)
            self.user =  try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func removeFavoriteMovie(){
        guard let user else { return }
        
        Task {
            try await UserManager.shared.removeFavoriteMovie(userId: user.userId)
            self.user =  try await UserManager.shared.getUser(userId: user.userId)
        }
    }
}

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    let preferenceOptions: [String] = ["Sports","Books","Movies"]
    
    private func preferenceSelected(text: String) -> Bool {
        viewModel.user?.preferences?.contains(text) == true
    }
    
    var body: some View {
        List{
            if let user = viewModel.user {
                Text("UserId: \(user.userId)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("Is anonymour: \(isAnonymous.description.capitalized)")
                }
                
                Button {
                    viewModel.togglePremiumStatus()
                } label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                }
                
                
                VStack {
                    HStack {
                        
                        ForEach(preferenceOptions,id: \.self){ item in
                            Button(item) {
                                
                                if preferenceSelected(text: item){
                                    viewModel.removeUserPreference(text: item)
                                } else {
                                    viewModel.addUserPreference(text: item)
                                }
                                
                            }
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint( preferenceSelected(text: item) ?.green : .red)
                            
                        }

                    }
                    
                    Text("User preferences: \((user.preferences ?? []).joined(separator: ","))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    if user.favoriteMovie == nil {
                        viewModel.addFavoriteMovie()
                    } else {
                        viewModel.removeFavoriteMovie()
                    }
                } label: {
                    Text("Favorite Movie: \(user.favoriteMovie?.title ?? "")")
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
