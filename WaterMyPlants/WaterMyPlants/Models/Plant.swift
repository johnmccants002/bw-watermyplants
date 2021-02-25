//
//  Plant.swift
//  WaterMyPlants
//
//  Created by John McCants on 2/24/21.
//

import Foundation
import UIKit

class Plant {
    var id : Int
    var nickname : String
    var species : String
    var h2oFrequency: String
    var image : UIImage?
    
    init(id: Int, nickname: String, species: String, h2oFrequency: String) {
        self.id = id
        self.nickname = nickname
        self.species = species
        self.h2oFrequency = h2oFrequency
    }
}
