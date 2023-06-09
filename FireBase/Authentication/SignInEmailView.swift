//
//  SignInEmailView.swift
//  FireBase
//
//  Created by Kaplan on 31/05/23.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewViewModel()
    @State private var showAlert = false
    @State private var disableSignUp = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    @Binding var showSignInView: Bool

    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            Button {
                viewModel.signIn { result in
                    switch (result) {
                    case .sucess(let value):
                        if let user = value as? AuthDataResultModel {
                            alertMessage = user.uid
                            showSignInView = false
                        }
                    case .status(let status):
                        print(status)
                    case .error(let error):
                        alertMessage = error
                        showAlert = true
                        if alertMessage.contains("already in use by another") {
                            alertMessage = "\(alertMessage) \n so please login into app or try with different user"
                            disableSignUp = true
                        }
                    }
                }
                
            } label: {
                Text("Sign Up ")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
            }.disabled(disableSignUp)
                .opacity(disableSignUp ? 0.2:1.0)
            
            Button("Sign") {
                Task {
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
            }.font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
            /*
            Button(action: {
                //To dismiss from navigation
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Spacer()
                    
                    Text("Need to Login")
                    Text("Click Here")
                        .fontWeight(.black)
                        .underline()
                }
            })
             .padding()
            */
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Alert"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
         
        }
        .padding()
        Spacer()
            .navigationTitle("Sign In With Email")
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
