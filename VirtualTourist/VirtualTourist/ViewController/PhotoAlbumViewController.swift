//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Dunning Nicholas, EV-44 on 21.06.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var noPhotosLabel: UILabel!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var dataController: DataController!

    var pin: Pin!

    var fetchedResultsController: NSFetchedResultsController<Photo>!

    var photoAlbumDetails: PhotoAlbumDetails!

    var photoDownloadData: [FlickrPhoto]?

    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predecate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predecate
        fetchRequest.sortDescriptors = []

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }

        if let photos = fetchedResultsController.fetchedObjects {
            if photos.count == 0 {
                self.photoAlbumDetails = PhotoAlbumDetails()
            } else {
                self.photoAlbumDetails = PhotoAlbumDetails(hasStoredPhotos: true)
            }
        }
    }

    fileprivate func setupCollectionFlow() {
        let space: CGFloat = 3.0
        let width = (self.view.frame.size.width - (2 * space)) / 3.0
        let height = (self.view.frame.size.height - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }

    fileprivate func setupMap() {
        let centerLocation = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        mapView.setCenter(centerLocation, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = pin.latitude
        annotation.coordinate.longitude = pin.longitude
        mapView.addAnnotation(annotation)

        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude), latitudinalMeters: 1500, longitudinalMeters: 1500), animated: true)
    }

    fileprivate func populatePhotoCollection() {
        if !photoAlbumDetails.hasStoredPhotos {
            FlickrRequest.requestPhotosForLocation(pin: pin, page: photoAlbumDetails.currentPage, completionHandler: handlePhotoSearch(photos:error:))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.noPhotosLabel.isHidden = true
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: pin.latitude, longitude: pin.longitude)) {
            placemarks, error in
            if error != nil {
                self.locationNameLabel.text = "Unknown Location"
            }

            if let placemarks = placemarks, placemarks.count != 0, let name = placemarks[0].name, let locality = placemarks[0].locality {
                self.locationNameLabel.text = "\(name), \(locality)"
            } else {
                self.locationNameLabel.text = "Unknown Location"
            }
        }

        self.photoCollection.delegate = self
        self.photoCollection.dataSource = self

        setupFetchedResultsController()
        setupCollectionFlow()
        setupMap()

        populatePhotoCollection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.photoCollection.reloadData()
    }

    func handlePhotoSearch(photos: FlickrPhotoSearch?, error: Error?) {
        if let error = error {
            print("ERROR: \(error.localizedDescription.description)")
        }

        guard let photos = photos else {
            return
        }

        if photos.photos.photo.count == 0 {
            noPhotosLabel.isHidden = false
        } else {
            noPhotosLabel.isHidden = true
            self.photoAlbumDetails.currentPage = photos.photos.page
            self.photoAlbumDetails.photoDownloadData = photos.photos.photo
        }
    }
}

extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.photoAlbumDetails.hasStoredPhotos) {
            return self.fetchedResultsController.fetchedObjects?.count ?? 0
        } else {
            return self.photoAlbumDetails.numberOfPhotosToDownload
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if (self.photoAlbumDetails.hasStoredPhotos) {
            let storedPhoto = fetchedResultsController.object(at: indexPath)
            if let photoData = storedPhoto.photo, let image = UIImage(data: photoData)  {
                cell.imageView.image = image
            }
        } else {
            let photoToDownload = self.photoAlbumDetails.photoDownloadData[indexPath.row]
            FlickrRequest.requestPhoto(photo: photoToDownload) { data, error in
                if let error = error {
                    print(error.localizedDescription.description)
                    return
                }
                print("Download complete!")

                guard let data = data else {
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    cell.imageView.image = image

                    let photo = Photo(context: self.dataController.viewContext)
                    photo.photo = data
                    photo.pin = self.pin
                    try? self.dataController.viewContext.save()
                }
            }
        }
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate {

}
