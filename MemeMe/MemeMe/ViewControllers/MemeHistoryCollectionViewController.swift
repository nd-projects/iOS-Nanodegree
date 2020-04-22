//
//  MemeHistoryCollectionViewController.swift
//  MemeMe
//
//  Created by Dunning Nicholas, EV-44 on 13.04.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class MemeHistoryCollectionViewController: UICollectionViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        guard let appDelegate = object as? AppDelegate else {
            return [Meme]()
        }
        return appDelegate.memes
    }

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

        let space: CGFloat = 3.0
        let width = (self.view.frame.size.width - (2 * space)) / 3.0
        let height = (self.view.frame.size.height - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addMeme))
        self.tabBarController?.tabBar.isHidden = false
        self.collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionViewCell", for: indexPath)
            as? MemeCollectionCell
        let meme = self.memes[(indexPath as NSIndexPath).row]

        cell?.memeCollectionImageView.image = meme.memedImage

        return cell!
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController")
        guard let memeDetailController = controller as? MemeDetailViewController else {
            return
        }

        memeDetailController.meme = self.memes[(indexPath as NSIndexPath).row]

        if let navigationController = navigationController {
            navigationController.pushViewController(memeDetailController, animated: true)
        }
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
