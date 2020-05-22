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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Clear the email and password?
    }

    // func: Handle the response to the login request
    // If error, display in label and reset button stext/state
    // If success, transition to map view along with session info

    @IBAction func login(_ sender: Any) {

        UdacityDataAPI.requestLogin(username: self.emailField.text!, password: self.passwordField.text!, completionHandler: handleLoginAttempt(loginData:error:))
    }

    func handleLoginAttempt(loginData: LoginData?, error: Error?) {

        if let error = error {
            DispatchQueue.main.async {
                self.errorLabel.text = error.localizedDescription
            }
            return
        }

        if let loginData = loginData {
            DispatchQueue.main.async {
                print("Login authenticated")
                self.segueToPins(loginData: loginData)
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.errorLabel.text = "No login data"
            }
        }
    }

    private func segueToPins(loginData: LoginData) {

        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PinController")
        guard let pinsViewController = controller else {
            return
        }

        SharedData.instance.currentSession = loginData
        if let navigationController = navigationController {
            navigationController.pushViewController(pinsViewController, animated: true)
        }
    }
}

