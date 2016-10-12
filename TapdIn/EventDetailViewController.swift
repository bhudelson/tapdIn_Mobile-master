//
//  EventDetailViewController.swift
//  TapdIn
//
//  Created by James Rainville on 9/19/16.
//  Copyright © 2016 Jim Rainville. All rights reserved.
//

import UIKit
import CoreLocation

class EventDetailViewController: UIViewController, UITabBarDelegate {
    var eventDetail:Dictionary<String, AnyObject> = [:]
    var downloadTask: URLSessionDownloadTask?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tabbar: UITabBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbar.delegate = self
        
        nameLabel.text = eventDetail["name"] as? String
        locationLabel.text = eventDetail["location_name"] as? String
        
        getAddressFromLoc(location: eventDetail["location"] as! String)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        let startTime = dateFormatter.date(from: (eventDetail["end_time"] as? String)!)
        // let endTime = dateFormatter.date(from: (eventDetail["end_time"] as? String)!)
        
        dateFormatter.dateFormat = "EEEE MMMM dd h:mm a"///this is you want to convert format
        // dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let startTimeFormatted = dateFormatter.string(from: startTime!)
        // let endTimeFormatted = dateFormatter.string(from: endTime!)
        
        
        startTimeLabel.text = startTimeFormatted
        // endTimeLabel.text = endTimeFormatted
        // print (startTimeFormatted)
        // print (endTime)
        
        // print (eventDetail)


        self.image.image = UIImage(named: "Placeholder")
        if let url = URL(string: eventDetail["image_poster"] as! String) {
            downloadTask = self.image.loadImage(url: url)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goto_tapin" {
            let tapInViewController = segue.destination as! TapInViewController
            tapInViewController.eventDetail = self.eventDetail
        }
        else if segue.identifier == "goto_tapout" {
            let tapOutViewController = segue.destination as! TapOutViewController
            tapOutViewController.eventDetail = self.eventDetail
        }
    }
    
    // MARK: - UITabBarDelegate Methods
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 1) {
            print ("Tap In was pressed")
            performSegue(withIdentifier: "goto_tapin", sender:self)
        }
        else if(item.tag == 2) {
            print ("Tap Out was pressed")
            performSegue(withIdentifier: "goto_tapout", sender:self)
        }
    }
    
    func getAddressFromLoc(location: String) {
        // print (location)
        var latAndLong = location.components(separatedBy: ",")
        // print(latAndLong[0])
        // print(latAndLong[1])
        
        let longitude = Double(latAndLong[1])
        let latitude  = Double(latAndLong[0])
        
        let location = CLLocation(latitude: latitude!, longitude: longitude!) //changed!!!
        // print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            // print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                // let address = String(format:"%s %s", (pm?.subThoroughfare)!, (pm?.thoroughfare)!)
                let address = (pm?.subThoroughfare)! + " " + (pm?.thoroughfare)! + " " + (pm?.locality)! + ", " + (pm?.administrativeArea)!
                
                // print(address)
                self.addressLabel.text = address
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }

}
