//
//  SettingsView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/11/23.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadProviders() throws {
        if let providers = try? AuthenticationManger.shared.getProviders(){
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try? AuthenticationManger.shared.signOut()
    }
    
    func resetPassword() async throws {
        
        let authenticatedUser = try AuthenticationManger.shared.getAuthenticatedUser()
        
        guard let email = authenticatedUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManger.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "hello@email.com"
        try await AuthenticationManger.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
      let password = "12345"
        try await AuthenticationManger.shared.updatePassword(password: password)
    }
}

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button {
                do{
                   try viewModel.signOut()
                   showSignInView = true
                } catch {
                    print(error)
                }
            } label: {
                Text("Logout")
            }
            
            if viewModel.authProviders.contains(.email){
                emailSection
            }
            
        }
        .onAppear {
           try? viewModel.loadProviders()
        }
        
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}


extension SettingsView {
    
    var emailSection: some View {
        Section {
            Button {
                Task {
                    do{
                       try await viewModel.resetPassword()
                      print("Password reset successfully")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Reset password")
            }
            
            Button {
                Task {
                    do{
                       try await viewModel.updatePassword()
                      print("Password updated successfully")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Update password")
            }
            
            Button {
                Task {
                    do{
                       try await viewModel.updateEmail()
                      print("Email updated successfully")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Update Email")
            }
        } header: {
            Text("Email Functions")
        }
    }
}
