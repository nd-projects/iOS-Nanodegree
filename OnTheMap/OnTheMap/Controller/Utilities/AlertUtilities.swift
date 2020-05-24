//
//  AlertUtilities.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 22.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation
import UIKit

class AlertUtilities {

    class func showAlert(title: String, message: String, parent: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        parent.present(alertController, animated: true, completion: nil)
    }
}
