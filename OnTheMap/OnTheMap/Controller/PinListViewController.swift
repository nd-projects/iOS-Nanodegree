//
//  PinListViewController.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 21.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation
import UIKit

class PinListViewController : UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        UdacityDataAPI.requestLocationPins()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedData.instance.pins?.results.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinCell")!
        guard let pin = SharedData.instance.pins?.results[(indexPath as NSIndexPath).row] else {
            return UITableViewCell()
        }


        cell.textLabel?.text = pin.firstName + " " + pin.lastName
        //cell.imageView?.image = UIImage(named: villain.imageName)

        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = pin.mediaURL
        }

        return cell
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController")
//        guard let memeDetailController = controller as? MemeDetailViewController else {
//            return
//        }
//
//        memeDetailController.meme = self.memes[(indexPath as NSIndexPath).row]
//
//        if let navigationController = navigationController {
//            navigationController.pushViewController(memeDetailController, animated: true)
//        }
//    }
}
