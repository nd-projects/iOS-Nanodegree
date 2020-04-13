//
//  MemeHistoryTableViewController.swift
//  MemeMe
//
//  Created by Dunning Nicholas, EV-44 on 13.04.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class MemeHistoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
