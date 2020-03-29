//
//  ViewController.swift
//  TextFieldDelegates
//
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var lockableTextField: UITextField!
    @IBOutlet weak var editLockSwitch: UISwitch!
    
    let zipCodeDelegate = ZipCodeDelegate();
    let currencyDelegate = CurrencyDelegate();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.zipTextField.delegate = zipCodeDelegate
        self.zipTextField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        
        self.currencyTextField.delegate = currencyDelegate
        self.lockableTextField.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return editLockSwitch.isOn
    }
}

