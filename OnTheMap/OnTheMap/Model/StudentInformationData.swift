//
//  PinData.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 21.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation

struct StudentInformationData: Codable {
    let results: [StudentInformation]
}

struct StudentInformation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}

struct StudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
