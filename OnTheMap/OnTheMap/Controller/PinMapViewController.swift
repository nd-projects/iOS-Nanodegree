//
//  PinMapViewController.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 21.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PinMapViewController : UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityInidcator: UIActivityIndicatorView!
    @IBOutlet weak var overlayView: UIView!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                LinkUtilities.OpenLink(toOpen)
            }
        }
    }

    private func loadData() {
        self.activityInidcator.startAnimating()
        self.overlayView.alpha = 0.5

        if let locations = SharedData.instance.pins {
            addAnnotations(locations: locations)
        }
        else {
            UdacityDataAPI.requestLocationPins { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self.activityInidcator.stopAnimating()
                        self.overlayView.alpha = 0.0
                        AlertUtilities.showAlert(title: "Error: Could not get location data", message: error.localizedDescription.description, parent: self)
                    }
                    return
                }
                else {
                    DispatchQueue.main.async {
                        self.addAnnotations(locations: SharedData.instance.pins!)
                    }
                }
            }
        }
    }

    private func addAnnotations(locations: StudentInformationData) {

        var annotations = [MKPointAnnotation]()
        for student in locations.results {
            let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
            let annotation = MKPointAnnotation()

            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL

            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)

        self.activityInidcator.stopAnimating()
        self.overlayView.alpha = 0.0
    }
}
