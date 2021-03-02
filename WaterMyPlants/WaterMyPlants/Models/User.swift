//
//  User.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import Foundation

class User {
    var username: String
    var email: String
    var uid: String
    init(username: String, email: String, uid: String) {
        self.username = username
        self.uid = uid
        self.email = email
    }
}
