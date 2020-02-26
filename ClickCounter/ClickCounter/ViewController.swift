//
//  ViewController.swift
//  ClickCounter
//
//  Created by Dunning Nicholas, EV-44 on 26.02.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var count = 0
    var label: UILabel!
    
    fileprivate func createLabel() {
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 150, width: 60, height: 60)
        label.text = "0"
        view.addSubview(label)
        self.label = label
    }
    
    fileprivate func createButton() {
        let button = UIButton()
        button.frame = CGRect(x: 150, y: 250, width: 60, height: 60)
        button.setTitle("Click", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        view.addSubview(button)
    }
    
    fileprivate func setupUIElements() {
        createLabel()
        createButton()
    }
    
    func incrementCount() {
        self.count += 1
        self.label.text = "\(self.count)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
    }
}
