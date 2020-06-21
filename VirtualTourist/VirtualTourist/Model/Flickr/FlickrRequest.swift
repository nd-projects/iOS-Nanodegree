//
//  FlikrRequest.swift
//  VirtualTourist
//
//  Created by Dunning Nicholas, EV-44 on 21.06.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation

class FlickrRequest {
    static var apiKey: String {
        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
            return nsDictionary?.value(forKey: "FlickrAPI") as! String
        }
        return ""
    }

    class func requestPhotosForLocation(pin: Pin, page: Int, completionHandler: @escaping(FlickrPhotoSearch?, Error?) -> Void) {
        print("Getting photos for location")
        let searchMethod = "https://www.flickr.com/services/rest?method=flickr.photos.search"
        let locationURL = URL(string: "\(searchMethod)&lat=\(pin.latitude)&lon=\(pin.longitude)&page=\(page)&format=json&nojsoncallback=1&api_key=\(FlickrRequest.apiKey)")!
        print(locationURL)
        let task = URLSession.shared.dataTask(with: locationURL) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }

            do {
                let pinData = try JSONDecoder().decode(FlickrPhotoSearch.self, from: data)
                completionHandler(pinData, nil)
                return
            }
            catch let error {
                completionHandler(nil, error)
                return
            }
        }
        task.resume()
    }
}
