//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Rahaf Naif on 23/10/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import Foundation

struct LoginResponse : Codable {
    let account : Account
    let session : Session

}

struct Account : Codable {
    let registered : Bool
    let key : String
}

struct Session : Codable {
    let id : String
    let expiration : String
    
}
