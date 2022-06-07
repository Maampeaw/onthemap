//
//  UdacityClient.swift
//  On the Map
//
//  Created by user on 5/10/22.
//

import Foundation
import UIKit
import CoreLocation


class UDClient{
    static let baseUrl = "https://onthemap-api.udacity.com/v1"
    
    struct Auth {
        static var sessionId = ""
        static var uniqueKey = ""
        
    }
    

    enum Endpoints {
        case authenticationEndpoint
        case studentLocations
        case studentLocationsPaginated(Int, Int)
        case userInfo(String)
       
        
        var stringValue: String{
        switch self {
        case Endpoints.authenticationEndpoint:
            return "\(UDClient.baseUrl)/session"
        case Endpoints.studentLocations:
            return "\(UDClient.baseUrl)/StudentLocation"
        case let .studentLocationsPaginated(limit, skip):
            return "\(UDClient.baseUrl)/StudentLocation?limit=\(limit)&skip=\(skip)&order=-updatedAt"
        case let Endpoints.userInfo(key):
            return "\(UDClient.baseUrl)/users/\(key)"
            
     
            
        }
        }
        
        var url:URL {
            URL(string: stringValue)!
        }
        
        
    }
    
    class func taskForPostRequest<RequestType: Encodable, ResponseType: Decodable>(url:URL, responseType:ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?)->()){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        
        
        
    }
    
    class func taskForGetRequest(){
        
    }
    
    
    
    
//    ----------------------------------------------------------------------------------------------------------------------------------
//    Post to get session so you can login Successfully
    
    class func postToGetSession(username:String, password:String, completion: @escaping (SessionResponse?, Error?)->Void){
        var request = URLRequest(url: Endpoints.authenticationEndpoint.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        let userInfo = UserInformation(username: username, password: password)
        let dataToServer = AuthenticationBody(udacity: userInfo)
        
        
        let encoded = try! JSONEncoder().encode(dataToServer)
     
        request.httpBody = encoded
      
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                  
                }
                return
                }
            
            
            let decoded = JSONDecoder()
            
            let realDataRange = 5 ..< data.count
            let newData = data.subdata(in: realDataRange)
           
            
            do{
                let decodedData = try decoded.decode(SessionResponse.self, from: newData)
                DispatchQueue.main.async{
                    completion(decodedData, nil)
                }
     
            }catch{
                do{
                    let errorResponse = try decoded.decode(errorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                    
                }catch{
                DispatchQueue.main.async{
                    completion(nil, error)
                }
                }
            }
        }
        task.resume()
    }
//    ----------------------------------------------------------------------------------------------------------------------------------
    
  
    
    
    
    
//    ------------------------------------------------------------------------------------------------------------------------------------
    //get Student's locations
    class func getStudentLocations(limit:Int, skip:Int, completion: @escaping (StudentLocationsResults?, Error?)->Void){
        let url  = UDClient.Endpoints.studentLocationsPaginated(limit, skip).url
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let decoded = try decoder.decode(StudentLocationsResults.self, from: data)
                completion(decoded, nil)
            }catch {
                print(error.localizedDescription)
                completion(nil, error)
            }

        }
        task.resume()
        
        
    }
//    -----------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
    
    
    
    
    class func checkIfAlreadyPosted(){
        let url = UDClient.Endpoints.studentLocations.url
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                DispatchQueue.main.async {
                    print("failed request")
                }
                
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(StudentLocationsResults.self, from:data)
                let theKeyArray = (Array(decoded.results)).map{
                    (studentLocation) in studentLocation.uniqueKey
                }
                print(UDClient.Auth.sessionId)
                if theKeyArray.contains(UDClient.Auth.uniqueKey){
                    
                    print("already there")
                }
                print(theKeyArray)
                
                
            }catch {
                print(error.localizedDescription)
                print("this failed")
            }
        }
        task.resume()
        
    }
    


    
//----------------------------------------------------------------------------------------------------------------------------------------
//    Post Student Info into db.
    class func postStudentInfo(_ body: StudentInfo, completion: @escaping(PostStudentInfoResponse?, Error?)->()){
        var request = URLRequest(url: Endpoints.studentLocations.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
                return
            }
            
            do{
                let decoded = try JSONDecoder().decode(PostStudentInfoResponse.self, from: data)
                DispatchQueue.main.async{
                    completion(decoded, nil)
                }
            }catch{
                do {
                    let decodedError = try JSONDecoder().decode(postErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, decodedError)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
                
                
            }
            
           
            
        }
        task.resume()
        
        
    }
    
    class func deleteSession(completion: @escaping (deleteSessionResponse?, Error?)->()){
        var request = URLRequest(url: Endpoints.authenticationEndpoint.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                   
                }
                return
               
            }
            
            let decoder = JSONDecoder()
            
            do{
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                let decoded = try decoder.decode(deleteSessionResponse.self, from: newData)
              
                DispatchQueue.main.async {
                    completion(decoded, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                
                
            }
            
           
            
            
        }
        task.resume()
        
        
    }
    
    //--------------------------------------------------------------------------------------------------------------------
    //getting User's Information
    class func getUserInfo(completion: @escaping(User?, Error?)->()){
        
        let url  = Endpoints.userInfo(UDClient.Auth.uniqueKey).url
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            let decoder = JSONDecoder()
            
            guard let data=data else{
                DispatchQueue.main.async {
                    print(error!.localizedDescription)
                    completion(nil, error)
                    
                }
                return
            }
            let realDataRange = 5 ..< data.count
            let newData = data.subdata(in: realDataRange)
            
            do {
                let decodedData = try decoder.decode(User.self, from: newData)
                DispatchQueue.main.async {
                    print(decodedData)
                    completion(decodedData, nil)
                }
            }catch{
                print(error)
            }
        }
        
        task.resume()
        
        
        
    }

    
}
//----------------------------------------------------------------------------------------------------------------------------------------



