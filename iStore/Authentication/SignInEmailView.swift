//
//  SigninEmailView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/11/23.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    
    @Published var email:String = ""
    @Published var password: String = ""
    
    
    func signIn(){
        guard  !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        Task{
            do{
                let returnedUserData =
                try await AuthenticationManger.shared.createUser(email: email, password: password)
                
            } catch {
                print ("Error: \(error)")
            }
        }
    }
}

struct SigninEmailView: View {
    
    @StateObject private var vm = SignInEmailViewModel()
    
    var body: some View {
        ZStack {
            
//            Image("logo")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
            
            VStack {
                
                TextField("Email...", text: $vm.email)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                SecureField("Password...", text: $vm.password)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                Button {
                    vm.signIn()
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(.blue)
                        .cornerRadius(10)
                }
                
                Spacer()

                
            }
            .padding()
            .navigationTitle("Sign In With Email")
        }
    }
}

struct SigninEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SigninEmailView()
        }
    }
}
