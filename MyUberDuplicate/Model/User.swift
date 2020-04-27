//
//  User.swift
//  MyUberDuplicate
//
//  Created by Eric Grant on 26.04.2020.
//  Copyright © 2020 Eric Grant. All rights reserved.
//

import CoreLocation

struct User {
    let fullname: String
    let email: String
    let accountType: Int
    var location: CLLocation?
    
    init(dictionary: [String: Any]) {
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? Int ?? 0
    }
}


