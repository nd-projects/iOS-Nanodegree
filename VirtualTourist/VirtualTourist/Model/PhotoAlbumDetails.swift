//
//  PhotoAlbum.swift
//  VirtualTourist
//
//  Created by Dunning Nicholas, EV-44 on 22.06.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation

struct PhotoAlbumDetails {
    var hasStoredPhotos: Bool = false
    var numberOfPhotosToDownload: Int { return photoDownloadData.count }
    var currentPage: Int = 1
    var photoDownloadData: [FlickrPhoto] = [FlickrPhoto]()
}
