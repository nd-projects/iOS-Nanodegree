//
//  LinkUtilities.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 24.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation
import UIKit

class LinkUtilities {

    class func OpenLink(_ link: String) {
        let app = UIApplication.shared

        let validURL = link.hasPrefix("http") ? link : "http://\(link)"
        app.open(URL(string: validURL)!)
    }
}
