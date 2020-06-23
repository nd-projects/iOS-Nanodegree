//
//  UdacityLoginAPI.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 19.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation

class UdacityDataAPI {

    class func requestLogin(username: String, password: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        print("Attempting to login to Udacity")
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(nil, error)
                return
            }

            let dataSubset = cleanData(data)
            completionHandler(dataSubset, nil)
            return
        }
        task.resume()
    }

    class func requestLocationPins(completionHandler: @escaping(Error?) -> Void) {
        print("Getting location pins")
        let locationURL = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!
        let task = URLSession.shared.dataTask(with: locationURL) { (data, response, error) in
            guard let data = data else {
                completionHandler(error)
                return
            }

            do {
                let pinData = try JSONDecoder().decode(StudentInformationData.self, from: data)
                SharedData.instance.pins = pinData
                completionHandler(nil)
                return
            }
            catch let error {
                completionHandler(error)
                return
            }
        }
        task.resume()
    }

    class func requestExistingLocation() {
        print("Checking if user already has a location")
    }

    class func postNewLocation(location: StudentLocation, completionHandler: @escaping(Error?) -> Void) {
        print("Posting a new location")
        let locationURL = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!
        var request = URLRequest(url: locationURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(location)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completionHandler(error)
            return
        }
        task.resume()
    }

    class func updateExistingLocation() {
        print("Updating an existing location")
    }

    class func logout(completionHandler: @escaping(Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(error)
                return
            }
            let dataSubset = cleanData(data)
            print(String(data: dataSubset!, encoding: .utf8)!)
            completionHandler(nil)
            SharedData.instance.currentSession = nil
            SharedData.instance.currentUser = nil
            SharedData.instance.pins = nil
        }
        task.resume()
    }

    class func cleanData(_ data: Data?) -> Data? {
        let range = Range(uncheckedBounds: (lower: 5, upper: data!.count))
        return data?.subdata(in: range)
    }
}
