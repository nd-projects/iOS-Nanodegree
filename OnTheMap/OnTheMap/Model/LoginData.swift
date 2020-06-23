//
//  LoginData.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 21.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation

struct LoginData: Codable {
    let account: AccountData
    let session: SessionData

    struct AccountData: Codable {
        let registered: Bool
        let key: String
    }

    struct SessionData: Codable {
        let id: String
        let expiration: String
    }
}
