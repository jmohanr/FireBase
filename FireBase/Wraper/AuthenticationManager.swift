//
//  AuthenticationManager.swift
//  FireBase
//
//  Created by Kaplan on 31/05/23.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let email: String?
    let uid: String
    let photoURL: String?
    
    init(user: User) {
        self.email = user.email
        self.uid = user.uid
        self.photoURL = user.photoURL?.absoluteString
    }
}

enum Result<T> {
    case sucess(T)
    case status(Bool)
    case error(String)
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    @discardableResult
    func getAuthUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    func createUser(email: String, password: String, completion: @escaping((Result<Any>)->Void))  {
        Auth.auth().createUser(withEmail: email, password: password) { (authresults,error) in
            if error == nil {
                if let result = authresults?.user {
                    let user = AuthDataResultModel(user: result)
                    completion(Result.sucess(user))
                } else {
                    completion(Result.status(false))
                }
            } else {
                completion(Result.error(error?.localizedDescription ?? ""))
            }
        }
    }
    
    @discardableResult
    func loginUser(email: String, password: String) async throws ->AuthDataResultModel {
        let results = try  await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: results.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
