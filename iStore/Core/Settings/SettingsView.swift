//
//  SettingsView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/11/23.
//

import SwiftUI



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
