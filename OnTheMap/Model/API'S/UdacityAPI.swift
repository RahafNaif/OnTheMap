//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Rahaf Naif on 21/10/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import Foundation

class UdacityAPI {
    
    struct Auth {

    static var key = ""
    static var sessionId = ""
        
    }
    
    class func postSession(username: String, password: String, completionHandler: @escaping (Bool,Error?)->Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
            print(error!)
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
            do{
               let responseObject = try JSONDecoder().decode(LoginResponse.self, from: newData!)
                DispatchQueue.main.async {

                  completionHandler(true, nil)
                  Auth.key = responseObject.account.key
                  Auth.sessionId = responseObject.session.id
                }
            }catch{
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
            }


          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
        class func deleteSession(completionHandler: @escaping (Error?)->Void){
    
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
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
          if error != nil { // Handle error…
            print(error!)
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
          completionHandler(nil)
        }
        task.resume()
    }
    
    class func getPublicUser(completionHandler: @escaping (String?)->Void){
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(Auth.key)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
            print(error!)
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    
}
