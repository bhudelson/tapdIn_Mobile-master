//
//  TapOutViewController.swift
//  TapdIn
//
//  Created by James Rainville on 10/7/16.
//  Copyright © 2016 Jim Rainville. All rights reserved.
//

import UIKit

class TapOutViewController: UIViewController {
    
    var eventDetail:Dictionary<String, AnyObject> = [:]
    var userId:String = ""

    @IBOutlet weak var askingPrice: UITextField!
    @IBOutlet weak var lowestPrice: UITextField!
    @IBOutlet weak var tapOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tapOutButton.layer.cornerRadius = 10
        self.askingPrice.text = eventDetail["suggested_price"] as? String
        self.lowestPrice.text = eventDetail["suggested_price"] as? String
        
        // Get the user id - we will need it to do a segue.
        let prefs:UserDefaults = UserDefaults.standard
        self.userId = prefs.string(forKey: "USERID")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if segue.identifier == "goto_tapout_qr" {
            var jsonStr:String = ""
            let eventId = self.eventDetail["id"] as! Int
            let askingPrice = self.askingPrice.text!
            let lowestPrice = self.lowestPrice.text!
            let dataDict = ["action": "tap_out", "data": ["owner":self.userId,"event":eventId, "auction":  [ "asking_price":askingPrice, "lowest_price": lowestPrice]]] as [String : Any]
            do {
            let postData : NSData = try JSONSerialization.data(withJSONObject: dataDict, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            jsonStr = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            
            } catch let error as NSError {
                print(error)
            }
            let tapOutQRViewController = segue.destination as! TapOutQRViewController
            tapOutQRViewController.qrString = jsonStr

        }
    }
    

    @IBAction func tapOutButtonPressed(_ sender: AnyObject) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
