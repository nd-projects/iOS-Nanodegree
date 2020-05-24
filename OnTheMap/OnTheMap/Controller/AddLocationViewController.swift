//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 22.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    var location: StudentLocation?

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var overlayView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Try to fill the input fields already

        self.overlayView.alpha = 0
    }

    @IBAction func findLocation(_ sender: Any) {

        self.activityIndicator.startAnimating()
        self.overlayView.alpha = 0.5

        let geocoder = CLGeocoder()
        let locationText = locationField.text ?? ""
        geocoder.geocodeAddressString(locationText) { (clPlacemarks, error) in

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.overlayView.alpha = 0.0
            }

            if let clPlacemark = clPlacemarks?.first {
                self.segueToPreview(clPlacemark: clPlacemark)
            } else {
                AlertUtilities.showAlert(title: "Error: Address to GPS",
                                         message: "Location of \(locationText) could not be found", parent: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ConfirmLocationViewController
        vc.location = self.location
    }

    // MARK: - Private Functions

    private func segueToPreview(clPlacemark: CLPlacemark) {
        let newLocation = StudentLocation(
            uniqueKey: (SharedData.instance.currentSession?.account.key)!,
            firstName: "Udacity",
            lastName: "Student",
            mapString: self.locationField.text!,
            mediaURL: self.linkField.text!,
            latitude: clPlacemark.location!.coordinate.latitude,
            longitude: clPlacemark.location!.coordinate.longitude)
        self.location = newLocation
        self.performSegue(withIdentifier: "previewLocation", sender: nil)
    }

}
