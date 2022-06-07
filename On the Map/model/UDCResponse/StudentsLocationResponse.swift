//
//  StudentsLocationResponse.swift
//  On the Map
//
//  Created by user on 5/12/22.
//

import Foundation
import UIKit

struct StudentLocationsResults: Codable{
    var results: [StudentLocations]
    
}

struct StudentLocations: Codable {
    var firstName: String
    var lastName: String
    var longitude: Float
    var latitude: Float
    var mapString: String
    var mediaURL: String
    var uniqueKey: String
    var objectId: String
    var createdAt: String
    var updatedAt:  String
    
    
}
