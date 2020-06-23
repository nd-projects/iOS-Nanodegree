//
//  FlikrDataModel.swift
//  VirtualTourist
//
//  Created by Dunning Nicholas, EV-44 on 21.06.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation

struct FlickrPhotoSearch: Codable {
    let photos: FlickrPhotos
    let stat: String
}

struct FlickrPhotos: Codable {
    let page, pages, perPage: Int
    let total: String
    let photo: [FlickrPhoto]

    enum CodingKeys: String, CodingKey {
        case page, pages, total, photo
        case perPage = "perpage"
    }
}

struct FlickrPhoto: Codable {
    let id, owner, secret, server, title: String
    let farm, isPublic, isFriend, isFamily: Int

    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
}
