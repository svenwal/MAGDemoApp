//
//  Profile.swift
//
//  Created by Sven Walther on 12.09.18.
//  Copyright © 2018 CA Technologies. All rights reserved.
//

import Foundation

struct Profile: Codable {
    let firstname: String
    let lastname: String
    let accountId: String
    let address: Address
    
}

struct Address: Codable {
    let city: String
    let zip: String
    let street: String
}
