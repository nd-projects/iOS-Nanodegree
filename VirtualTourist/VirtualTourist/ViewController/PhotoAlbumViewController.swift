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

class PhotoAlbumViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoCollection: UICollectionView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var noPhotosLabel: UILabel!

    var dataController: DataController!

    var pin: Pin!

    override func viewDidLoad() {
        super.viewDidLoad()
        noPhotosLabel.isHidden = true
        
    }

}
