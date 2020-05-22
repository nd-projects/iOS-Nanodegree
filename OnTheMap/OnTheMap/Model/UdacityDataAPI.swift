//
//  UdacityLoginAPI.swift
//  OnTheMap
//
//  Created by Dunning Nicholas, EV-44 on 19.05.20.
//  Copyright © 2020 nd-projects. All rights reserved.
//

import Foundation

class UdacityDataAPI {

    class func requestLogin(username: String, password: String, completionHandler: @escaping (LoginData?, Error?) -> Void) {
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

            do {
                let dataSubset = cleanData(data)
                let loginData = try JSONDecoder().decode(LoginData.self, from: dataSubset!)
                completionHandler(loginData, nil)
                return
            }
            catch let error {
                completionHandler(nil, error)
                return
            }
        }
        task.resume()
    }

    class func requestLocationPins() {
        print("Getting location pins")
        let locationURL = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!
        let task = URLSession.shared.dataTask(with: locationURL) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let pinData = try JSONDecoder().decode(PinDataCollection.self, from: data)
                SharedData.instance.pins = pinData
                print(pinData)
                return
            }
            catch let error {
                print(error)
                return
            }
        }
        task.resume()
    }

    class func cleanData(_ data: Data?) -> Data? {
        let range = Range(uncheckedBounds: (lower: 5, upper: data!.count))
        return data?.subdata(in: range)
    }
}
