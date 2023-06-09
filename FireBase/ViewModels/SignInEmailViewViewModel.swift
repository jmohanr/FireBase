//
//  SignInEmailViewViewModel.swift
//  FireBase
//
//  Created by Kaplan2 on 01/06/23.
//

import SwiftUI

final class  SignInEmailViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn(completion: @escaping((Result<Any>) -> Void))   {
      
        guard !email.isEmpty, !password.isEmpty else {
            completion(Result.error("Check Email/Password"))
            return
        }
        
        AuthenticationManager.shared.createUser(email: email, password: password) { result in
          completion(result)
        }
        
    }
    
    func signIn()  async throws {
        guard !email.isEmpty, !password.isEmpty else {
            return
        }
        try await AuthenticationManager.shared.loginUser(email: email, password: password)

    }
}

final class SettingsViewViewModel: ObservableObject {
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let user = try AuthenticationManager.shared.getAuthUser()
        guard let email = user.email else { throw URLError(.fileDoesNotExist) }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
}
