//
//  User.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import Foundation

class User {
    var username: String
    var password: String
    var plants: [Plant] = []
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
