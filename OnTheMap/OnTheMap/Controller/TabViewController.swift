//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 22.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation
import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logout(_ sender: Any) {
        UdacityDataAPI.logout(completionHandler: handleLogoutAttempt(error:))
    }

    @IBAction func refresh(_ sender: Any) {
        UdacityDataAPI.requestLocationPins(completionHandler: handleLocationPinRequest(error:))
    }

    func handleLocationPinRequest(error: Error?) {
        guard let error = error else
        {
            return
        }
        AlertUtilities.showAlert(title: "Error: Getting Student Locations", message: error.localizedDescription.description, parent: self)
    }

    func handleLogoutAttempt(error: Error?)
    {
        if let error = error {
            DispatchQueue.main.async {
                AlertUtilities.showAlert(title: "Error: Logout Failure", message: error.localizedDescription.description, parent: self)
            }
        }
        else {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
