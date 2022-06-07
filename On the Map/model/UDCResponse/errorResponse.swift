//
//  errorResponse.swift
//  On the Map
//
//  Created by user on 5/11/22.
//

import Foundation
import UIKit

struct errorResponse: Codable, LocalizedError{
    var status: Int
    var error: String
    
    var errorDescription: String?{
        return error
    }
}


struct postErrorResponse: Codable, LocalizedError{
    var code: Int
    var error: String
    
    var errorDescription: String?{
        return error
    }
    
}
