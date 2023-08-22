//
//  SigninEmailView.swift
//  iStore
//
//  Created by Md Shohidur Rahman on 8/11/23.
//

import SwiftUI



struct SigninEmailView: View {
    
    @Binding var showSignInView: Bool
    
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
                    Task {
                        do{
                            try await vm.signUp()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                        }
                        
                        
                        do{
                            try await vm.signIn()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
                        }
                    }
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
            SigninEmailView(showSignInView: .constant(false))
        }
    }
}
