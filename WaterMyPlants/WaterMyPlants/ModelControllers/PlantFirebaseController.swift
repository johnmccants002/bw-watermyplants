//
//  PlantFirebaseController.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noData
    case failedSignUp
    case failedSignIn
    case noToken
    case tryAgain
    case failedDecoding
    case failedEncoding
    case failedResponse
    case noIdentifier
    case noRep
    case otherError
}

class PlantFirebaseController {
        
        private let firebaseURL = "https://plantapp-2fe47-default-rtdb.firebaseio.com/"
        let ref = Database.database().reference()
        var currentUser: User?
        
        static let shared = PlantFirebaseController()
        private init() { }
    
    func createUser(email: String, password: String, username: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let authResult = authResult {
                    let dict: [String: Any] = [
                        "uid": authResult.user.uid,
                        "username": username,
                        "email": authResult.user.email
                        ]
                print(self.ref.url)
                    Database.database().reference().child("users").child(authResult.user.uid).updateChildValues(dict, withCompletionBlock: { (error, _) in
                        if error == nil {
                            print("Done")
                        }
                })
        
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
}
