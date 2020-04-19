//
//  MemeHistoryTableViewController.swift
//  MemeMe
//
//  Created by Dunning Nicholas, EV-44 on 13.04.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class MemeHistoryTableViewController: UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        guard let appDelegate = object as? AppDelegate else {
            return [Meme]()
        }
        return appDelegate.memes
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addMeme))
        navigationItem.rightBarButtonItem?.isEnabled = true

        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell") as? MemeTableCell
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell?.memeTextLabel.text = meme.topText + " " + meme.bottomText
        cell?.memeTableImageView.image = meme.memedImage

        return cell!
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }

    @objc func addMeme() {
        let controller = self.storyboard?.instantiateViewController(identifier: "MemeEditorViewController")
        guard let memeEditorController = controller as? MemeEditorViewController else {
            return
        }
        if let navigationController = navigationController {
            navigationController.pushViewController(memeEditorController, animated: true)
        }
    }
}
