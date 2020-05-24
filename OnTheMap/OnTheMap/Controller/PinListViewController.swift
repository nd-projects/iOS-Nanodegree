//
//  PinListViewController.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 21.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation
import UIKit

class PinListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var overlayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedData.instance.pins?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinCell")!
        guard let pin = SharedData.instance.pins?.results[(indexPath as NSIndexPath).row] else {
            return UITableViewCell()
        }

        cell.textLabel?.text = "\(pin.firstName) \(pin.lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin.png")

        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = pin.mediaURL
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStudent = SharedData.instance.pins?.results[(indexPath as NSIndexPath).row]
        if let toOpen = selectedStudent?.mediaURL {
            LinkUtilities.OpenLink(toOpen)
        }
        
    }

    private func loadData() {
        if SharedData.instance.pins == nil {
            self.activityIndicator.startAnimating()
            self.overlayView.alpha = 0.5

            UdacityDataAPI.requestLocationPins { (error) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.overlayView.alpha = 0
                }
                if let error = error {
                    DispatchQueue.main.async {
                        AlertUtilities.showAlert(title: "Error: Could not get location data", message: error.localizedDescription.description, parent: self)
                    }
                    return
                }
                else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        else {
            self.overlayView.alpha = 0
            self.tableView.reloadData()
        }
    }
}
