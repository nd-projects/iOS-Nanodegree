//
//  SharedPinCollection.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 21.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation

class SharedData {
    static let instance = SharedData()
    var currentSession: LoginData?
    var currentUser: StudentLocation?
    var pins: StudentInformationData?
}
