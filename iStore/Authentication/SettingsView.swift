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
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() throws {
        if let providers = try? AuthenticationManager.shared.getProviders(){
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try? AuthenticationManager.shared.signOut()
    }
    
    func loadAuthUser() throws {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func resetPassword() async throws {
        
        let authenticatedUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authenticatedUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "hello@email.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
      let password = "12345"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkAppleAccount() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.linkApple(tokens: tokens)
    }
    
    func linkEmailAccount() async throws {
        let email = "email@email.com"
        let password = "123456"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
}

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button {
                Task {
                    do{
                       try viewModel.signOut()
                       showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Logout")
            }
            
            Button(role: .destructive) {
                Task {
                    do{
                       try await viewModel.deleteAccount()
                       showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Delete account ")
            }

            
            if viewModel.authProviders.contains(.email){
                emailSection
            }
            
            if ((viewModel.authUser?.isAnonymous) != nil) {
                anonymousSection
            }
            
        }
        .onAppear {
           try? viewModel.loadAuthProviders()
           try? viewModel.loadAuthUser()
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
    
    
    var anonymousSection: some View {
        Section {
            Button {
                Task {
                    do{
                       try await viewModel.linkGoogleAccount()
                      
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Link Google Account")
            }
            
            Button {
                Task {
                    do{
                       try await viewModel.linkAppleAccount()
                      
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Link Apple Account")
            }
            
            Button {
                Task {
                    do{
                       try await viewModel.linkEmailAccount()
                     
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Link Email Account")
            }
        } header: {
            Text("Create Account")
        }
    }
}
