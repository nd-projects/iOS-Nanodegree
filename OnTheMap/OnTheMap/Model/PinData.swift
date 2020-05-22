//
//  PinData.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 21.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation

struct PinDataCollection: Codable {
    let results: [SinglePinData]

    struct SinglePinData: Codable {
        let firstName: String
        let lastName: String
        let longitude: Float
        let latitude: Float
        let mapString: String
        let mediaURL: String
        let uniqueKey: String
        let objectId: String
        let createdAt: String
        let updatedAt: String
    }
}
