//
//  User.swift
//  On the Map
//
//  Created by user on 5/23/22.
//

import Foundation


struct User: Codable {
    let lastName: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey{
        case lastName = "last_name"
        case firstName = "first_name"
    }
    
}


