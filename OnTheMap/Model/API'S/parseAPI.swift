//
//  parseAPI.swift
//  OnTheMap
//
//  Created by Rahaf Naif on 15/10/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import Foundation

class parseAPI {
    
    enum Endpoint {
        case base
        case limit
        case skip
        case order
        case uniqueKey
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        

        var stringValue: String {
            switch self {
        
            case .base:
                return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .limit:
                return "?limit=100"
            case .skip:
                return "&skip=400"
            case .order:
                return "&order=-updatedAt"
            case .uniqueKey:
                return "uniqueKey=1234"
                
            }
        }
    }
    
    class func getRequest(completionHandler: @escaping (StudentLocationList?, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "\(Endpoint.base.url)\(Endpoint.limit.url)\(Endpoint.order.url)")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request ) { data, response, error in
          guard let data = data else {
              completionHandler(nil, error)
              return
          }
          let decoder = JSONDecoder()
          let student = try! decoder.decode(StudentLocationList.self, from: data)
          completionHandler(student , error)
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    class func postRequest(location:String,link:String,lat:Double,long:Double,completionHandler: @escaping (AddLocationResponse?, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(UdacityAPI.Auth.key)\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(link)\",\"latitude\": \(lat), \"longitude\": \(long)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          guard let data = data else {
              completionHandler(nil, error)
              return
          }
          let decoder = JSONDecoder()
          let student = try! decoder.decode(AddLocationResponse.self, from: data)
          completionHandler(student , error)
          print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func putRequest(completionHandler: @escaping (StudentLocationList?, Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation/\(UdacityAPI.Auth.key)")!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          guard let data = data else {
              completionHandler(nil, error)
              return
          }
          let decoder = JSONDecoder()
          let student = try! decoder.decode(StudentLocationList.self, from: data)
          completionHandler(student , error)
          print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
    
    
    
}
