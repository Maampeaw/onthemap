//
//  CreateStudentLocationRequest.swift
//  On the Map
//
//  Created by user on 5/13/22.
//

import Foundation
import UIKit


struct StudentInfo: Codable{
    var uniqueKey: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var mapString: String = ""
    var mediaURL: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
}
