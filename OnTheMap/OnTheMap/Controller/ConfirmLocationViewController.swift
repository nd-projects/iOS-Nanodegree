//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 22.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {

    var location: StudentLocation?

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.displayPin()
    }

    @IBAction func finish(_ sender: Any) {
        UdacityDataAPI.postNewLocation(location: self.location!, completionHandler: handlePostLocationAttempt(error:))
    }

    func handlePostLocationAttempt(error: Error?) {
        if let error = error {
            DispatchQueue.main.async {
                AlertUtilities.showAlert(title: "Error: Posting location", message: error.localizedDescription.description, parent: self)
            }
        }
        else {
            DispatchQueue.main.async {
                if let navigationController = self.navigationController {
                    navigationController.popToRootViewController(animated: true)
                }
            }
        }
    }

    private func displayPin() {
        let coordinate = CLLocationCoordinate2D(latitude: self.location!.latitude, longitude: self.location!.longitude)

        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = self.location!.mapString
        mapView.addAnnotation(annotation)
    }
}
