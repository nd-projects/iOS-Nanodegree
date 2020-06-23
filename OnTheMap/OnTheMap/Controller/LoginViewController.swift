//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 19.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Clear the email and password?
    }

    @IBAction func login(_ sender: Any) {

        UdacityDataAPI.requestLogin(username: self.emailField.text!, password: self.passwordField.text!, completionHandler: handleLoginAttempt(data:error:))
    }

    @IBAction func signup(_ sender: Any) {
        LinkUtilities.OpenLink("https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1589881348258000")
    }

    func handleLoginAttempt(data: Data?, error: Error?) {

        if error != nil {
            DispatchQueue.main.async {
                self.errorLabel.text = "Network connection error"
            }
            return
        }

        do {
            let loginData = try JSONDecoder().decode(LoginData.self, from: data!)
            DispatchQueue.main.async {
                self.segueToPins(loginData: loginData)
            }
        }
        catch _ {
            DispatchQueue.main.async {
                self.errorLabel.text = "Invalid Username/Password"
            }
        }
    }

    private func segueToPins(loginData: LoginData) {
        SharedData.instance.currentSession = loginData
        self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
    }
}

