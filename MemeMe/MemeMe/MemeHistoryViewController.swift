//
//  MemeHistoryController.swift
//  MemeMe
//
//  Created by Dunning Nicholas, EV-44 on 13.04.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class MemeHistoryViewController: UIViewController {
    var memes: [Meme] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        guard let appDelegate = object as? AppDelegate else {
            return
        }
        self.memes = appDelegate.memes
    }
}
