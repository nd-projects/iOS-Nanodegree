//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Dunning Nicholas, EV-44 on 22.04.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: Properties

    var meme: Meme!

    // MARK: Outlets

    @IBOutlet weak var imageView: UIImageView!

    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true

        self.imageView!.image = meme.memedImage
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
