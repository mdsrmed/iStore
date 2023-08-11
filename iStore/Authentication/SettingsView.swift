//
//  SettingsView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/11/23.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func signOut() throws {
        try? AuthenticationManger.shared.signOut()
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

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}
