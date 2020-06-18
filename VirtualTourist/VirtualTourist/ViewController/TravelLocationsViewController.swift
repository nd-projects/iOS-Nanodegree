//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Dunning Nicholas, EV-44 on 18.06.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    fileprivate func reloadMapPosition() {
        print("where were we last...")
        let lastCoord = CLLocation(latitude: UserDefaults.standard.double(forKey: UserDefaultsAccess.latitude.rawValue), longitude: UserDefaults.standard.double(forKey: UserDefaultsAccess.longitude.rawValue))

        let lastSpan = MKCoordinateSpan(latitudeDelta: UserDefaults.standard.double(forKey: UserDefaultsAccess.zoomLongitude.rawValue), longitudeDelta: UserDefaults.standard.double(forKey: UserDefaultsAccess.zoomLongitude.rawValue))

        let lastRegion = MKCoordinateRegion(center: lastCoord.coordinate, span: lastSpan)

        mapView.setRegion(lastRegion, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if(!UserDefaults.standard.bool(forKey: "hasLaunchedBefore")) {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")

            UserDefaults.standard.set(Double(0), forKey: UserDefaultsAccess.latitude.rawValue)
            UserDefaults.standard.set(Double(0), forKey: UserDefaultsAccess.longitude.rawValue)
            UserDefaults.standard.set(Double(50000), forKey: UserDefaultsAccess.zoomLatitude.rawValue)
            UserDefaults.standard.set(Double(60000), forKey: UserDefaultsAccess.zoomLongitude.rawValue)
        }

        reloadMapPosition()
    }
}

extension TravelLocationsViewController: MKMapViewDelegate {

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let mapCenterCoord = mapView.region.center
        let mapSpan = mapView.region.span

        UserDefaults.standard.set(Double(mapCenterCoord.latitude), forKey: UserDefaultsAccess.latitude.rawValue)
        UserDefaults.standard.set(Double(mapCenterCoord.longitude), forKey: UserDefaultsAccess.longitude.rawValue)

        UserDefaults.standard.set(Double(mapSpan.latitudeDelta), forKey: UserDefaultsAccess.zoomLatitude.rawValue)
        UserDefaults.standard.set(Double(mapSpan.longitudeDelta), forKey: UserDefaultsAccess.zoomLongitude.rawValue)
    }
}

