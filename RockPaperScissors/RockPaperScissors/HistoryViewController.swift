//
//  HistoryViewController.swift
//  RockPaperScissors
//
//  Created by Dunning Nicholas, EV-44 on 10.04.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

class HistoryViewController  : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var gameHistory: [String] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.gameHistory.count)
        return self.gameHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell")!
        let history = self.gameHistory[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = history

        return cell
    }

}
