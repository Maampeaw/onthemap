//
//  CreateSession.swift
//  On the Map
//
//  Created by user on 5/10/22.
//

import Foundation
import UIKit

struct AuthenticationBody: Codable{
    var udacity: UserInformation
}

struct UserInformation: Codable{
    var username: String
    var password: String
}

