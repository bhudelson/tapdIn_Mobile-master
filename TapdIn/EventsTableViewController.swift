//
//  EventsTableViewController.swift
//  TapdIn
//
//  Created by James Rainville on 9/16/16.
//  Copyright © 2016 Jim Rainville. All rights reserved.
//

import Foundation
import UIKit

class EventsTableViewController: UITableViewController {
    var apiToken:String?
    var eventList:[Dictionary<String, AnyObject>] = []
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateEventList()
        print (eventList)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        let prefs:UserDefaults = UserDefaults.standard
        prefs.removeObject(forKey: "USERID")
        prefs.removeObject(forKey: "APITOKEN")
        performSegue(withIdentifier: "goto_login", sender:self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Events"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let prefs:UserDefaults = UserDefaults.standard
        // let apiToken = return_values["token"]! as! String
        // if let city = prefs.stringForKey("userCity")
        if let apiKey = prefs.string(forKey: "APITOKEN") {
            self.apiToken = apiKey
        } else {
            print("going to login")
            performSegue(withIdentifier: "goto_login", sender:self)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell( withIdentifier: "Event_Cell", for: indexPath) as! EventTableViewCell

        let event = eventList[(indexPath as NSIndexPath).row]
        cell.nameLabel.text = event["name"] as? String
        cell.locationLabel.text = event["location_name"] as? String
        
        cell.eventImageView.image = UIImage(named: "Placeholder")
        if let url = URL(string: event["image_thumbnail"] as! String) {
            downloadTask = cell.eventImageView.loadImage(url: url)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goto_event_detail", sender: indexPath)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goto_event_detail" {
            let eventDetailViewController = segue.destination as! EventDetailViewController
            let indexPath = sender as! IndexPath
            let eventDetail = eventList[(indexPath as NSIndexPath).row]
            eventDetailViewController.eventDetail = eventDetail
        }
    }

    func populateEventList() {
        let serviceEndpoint = "events/"
        let rc = RESTAccess()
        
        rc.get([:], serviceEndpoint: serviceEndpoint) { (succeeded: Bool, msg: String, return_values: [Dictionary<String, AnyObject>]) -> () in
                
            if (succeeded) {
                self.eventList = return_values
                // Thread safety - need to run reloadData in the context of the main thread. 
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
                
                print (self.eventList)
            } else {
                let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { _ in
                }
                    
                alert.title = "Failed!"
                alert.addAction(action)
                    
                // Move to the UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    // Show the alert
                    self.present(alert, animated: true) {}
                    })
                }
                
            }
        
        }

}
