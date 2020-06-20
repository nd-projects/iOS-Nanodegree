//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Dunning Nicholas, EV-44 on 18.06.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    var dataController: DataController!

    var fetchedResultsController: NSFetchedResultsController<Pin>!

    var uiLongGesture: UILongPressGestureRecognizer!

    fileprivate func reloadMapPosition() {
        let lastCoord = CLLocation(latitude: UserDefaults.standard.double(forKey: UserDefaultsAccess.latitude.rawValue), longitude: UserDefaults.standard.double(forKey: UserDefaultsAccess.longitude.rawValue))

        let lastSpan = MKCoordinateSpan(latitudeDelta: UserDefaults.standard.double(forKey: UserDefaultsAccess.zoomLatitude.rawValue), longitudeDelta: UserDefaults.standard.double(forKey: UserDefaultsAccess.zoomLongitude.rawValue))

        let lastRegion = MKCoordinateRegion(center: lastCoord.coordinate, span: lastSpan)

        mapView.setRegion(lastRegion, animated: false)
    }

    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    fileprivate func reloadPins() {
        for pin in self.fetchedResultsController.fetchedObjects! {
            addAnnotation(CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFetchedResultsController()

        uiLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(dropPin(gestureRecognizer:)))
        uiLongGesture.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(uiLongGesture)

        if(!UserDefaults.standard.bool(forKey: "hasLaunchedBefore")) {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")

            UserDefaults.standard.set(Double(0), forKey: UserDefaultsAccess.latitude.rawValue)
            UserDefaults.standard.set(Double(0), forKey: UserDefaultsAccess.longitude.rawValue)
            UserDefaults.standard.set(Double(50000), forKey: UserDefaultsAccess.zoomLatitude.rawValue)
            UserDefaults.standard.set(Double(60000), forKey: UserDefaultsAccess.zoomLongitude.rawValue)
            UserDefaults.standard.synchronize()
        }
        else {
            reloadMapPosition()
            reloadPins()
        }

    }

    fileprivate func addAnnotation(_ coordinates: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }

    @objc func dropPin(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        addAnnotation(coordinates)

        let pin = Pin(context: dataController.viewContext)
        pin.latitude = coordinates.latitude
        pin.longitude = coordinates.longitude
        pin.creationDate = Date()
        try? self.dataController.viewContext.save()
        setupFetchedResultsController()
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

        UserDefaults.standard.synchronize()
    }
}
