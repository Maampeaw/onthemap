//
//  CreateSessionResponse.swift
//  On the Map
//
//  Created by user on 5/10/22.
//

import Foundation
import UIKit

struct SessionResponse: Codable{
    var account: AccountResponse
    var session: SessionResponseDetail
}

struct AccountResponse: Codable{
    var registered:Bool
    var key: String
}

struct SessionResponseDetail: Codable {
    var id: String
    var expiration: String
}


