//
//  RESTAccess.swift
//  OAI Kiosk
//
//  Created by James Rainville on 8/4/16.
//  Copyright © 2016 Jim Rainville. All rights reserved.
//

import Foundation

class RESTAccess {
    // let serverBase = "http://64.139.253.222/oai/api/v1/"
    let serverBase = "https://rainville.net/oai/api/v1/"
    
    var apiToken:String = ""
    
    init() {
        let prefs:UserDefaults = UserDefaults.standard
        if let apiKey = prefs.string(forKey: "APITOKEN") {
            self.apiToken = apiKey
        }
    }
    
    func post(_ params : Dictionary<String, AnyObject>, serviceEndpoint : String, postCompleted : @escaping (_ succeeded: Bool, _ msg: String, _ return_values: Dictionary<String, AnyObject>) -> ()) {
        
        let url = self.serverBase + serviceEndpoint
        guard let serviceURL = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        // let serviceUrlRequest = NSMutableURLRequest(url: serviceURL)
        var serviceUrlRequest = URLRequest(url: serviceURL)
        
        serviceUrlRequest.httpMethod = "POST"
        
        // let postDic = ["username": username, "password": password]
        let jsonPost: Data
        
        do {
            jsonPost = try JSONSerialization.data(withJSONObject: params, options: [])
            serviceUrlRequest.httpBody = jsonPost
            serviceUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if !self.apiToken.isEmpty {
                let token_str = "Token " + self.apiToken
                serviceUrlRequest.setValue(token_str, forHTTPHeaderField: "Authorization")
            }
        } catch {
            let msg = "Error: cannot create JSON from post info"
            postCompleted(false, msg, [:])
            print(msg)
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: serviceUrlRequest, completionHandler: {
            (data, response, error) in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            print ( statusCode )
            
            if (statusCode >= 200 && statusCode < 300) {
                
                guard let responseData = data else {
                    let msg = "Error: did not recieve data"
                    postCompleted(false, msg, [:])
                    print (msg)
                    return
                }
                
                guard error == nil else {
                    let msg = "Error calling POST /oai/api/v1/api-token-auth/"
                    postCompleted(false, msg, [:])
                    print (msg)
                    print (error)
                    return
                }
                
                // parse the result as JSON
                do {
                    guard let recievedData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                        let msg = "Could not get JSON from resonseData as dictionary"
                        postCompleted(false, msg, [:])
                        print (msg)
                        return
                    }
                    
                    postCompleted(true, "API Successful!", recievedData)
                    // print(recievedData)
                } catch {
                    let msg = "error parsing response from POST"
                    postCompleted(false, msg, [:])
                    print(msg)
                    return
                }
            } else {
                let msg = "API Call failed"
                postCompleted(false, msg, [:])
                print(msg)
            }
            
        }) 
        task.resume()
    }
    
    func get(_ params : Dictionary<String, AnyObject>, serviceEndpoint : String, postCompleted : @escaping (_ succeeded: Bool, _ msg: String, _ return_values: [Dictionary<String, AnyObject>]) -> ()) {
        
        let url = self.serverBase + serviceEndpoint
        guard let serviceURL = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        var serviceUrlRequest = URLRequest(url: serviceURL)
        serviceUrlRequest.httpMethod = "GET"
        serviceUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: serviceUrlRequest, completionHandler: {
            (data, response, error) in
            
            let statusCode = (response as? HTTPURLResponse)!.statusCode
            print ( statusCode )
            
            if (statusCode >= 200 && statusCode < 300) {
                
                guard let responseData = data else {
                    let msg = "Error: did not recieve data"
                    postCompleted(false, msg, [])
                    print (msg)
                    return
                }
                
                guard error == nil else {
                    let msg = "Error calling POST /oai/api/v1/api-token-auth/"
                    postCompleted(false, msg, [])
                    print (msg)
                    print (error)
                    return
                }
                
                // parse the result as JSON
                do {
                    guard let recievedData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [Dictionary<String, AnyObject>] else {
                        let msg = "Could not get JSON from resonseData as dictionary"
                        postCompleted(false, msg, [])
                        print (msg)
                        return
                    }
                    
                    postCompleted(true, "API Successful!", recievedData)
                    // print(recievedData)
                } catch {
                    let msg = "error parsing response from POST"
                    postCompleted(false, msg, [])
                    print(msg)
                    return
                }
            } else {
                let msg = "API Call failed"
                postCompleted(false, msg, [])
                print(msg)
            }
            
        }) 
        task.resume()
    }
    
    func patch(_ params : Dictionary<String, AnyObject>, serviceEndpoint : String, postCompleted : @escaping (_ succeeded: Bool, _ msg: String, _ return_values: Dictionary<String, AnyObject>) -> ()) {
        
        let url = self.serverBase + serviceEndpoint
        guard let serviceURL = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        var serviceUrlRequest = URLRequest(url: serviceURL)
        serviceUrlRequest.httpMethod = "PATCH"
        
        // let postDic = ["username": username, "password": password]
        let jsonPost: Data
        
        do {
            jsonPost = try JSONSerialization.data(withJSONObject: params, options: [])
            serviceUrlRequest.httpBody = jsonPost
            serviceUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if !self.apiToken.isEmpty {
                let token_str = "Token " + self.apiToken
                serviceUrlRequest.setValue(token_str, forHTTPHeaderField: "Authorization")
            }
        } catch {
            let msg = "Error: cannot create JSON from post info"
            postCompleted(false, msg, [:])
            print(msg)
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: serviceUrlRequest, completionHandler: {
            (data, response, error) in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            print ( statusCode )
            
            if (statusCode >= 200 && statusCode < 300) {
                
                guard let responseData = data else {
                    let msg = "Error: did not recieve data"
                    postCompleted(false, msg, [:])
                    print (msg)
                    return
                }
                
                guard error == nil else {
                    let msg = "Error calling POST /oai/api/v1/api-token-auth/"
                    postCompleted(false, msg, [:])
                    print (msg)
                    print (error)
                    return
                }
                
                // parse the result as JSON
                do {
                    guard let recievedData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                        let msg = "Could not get JSON from resonseData as dictionary"
                        postCompleted(false, msg, [:])
                        print (msg)
                        return
                    }
                    
                    postCompleted(true, "API Successful!", recievedData)
                    // print(recievedData)
                } catch {
                    let msg = "error parsing response from POST"
                    postCompleted(false, msg, [:])
                    print(msg)
                    return
                }
            } else {
                let msg = "API Call failed"
                postCompleted(false, msg, [:])
                print(msg)
            }
            
        }) 
        task.resume()
    }
    
}
