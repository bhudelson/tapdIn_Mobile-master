//
//  TapOutQRViewController.swift
//  TapdIn
//
//  Created by Jim Rainville on 10/9/16.
//  Copyright © 2016 Jim Rainville. All rights reserved.
//

import UIKit

class TapOutQRViewController: UIViewController {
    
    var qrString: String = ""
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let data = qrString.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        
        let qrImage:CIImage = filter!.outputImage!
        
        //qrImageView is a IBOutlet of UIImageView
        let scaleX = qrImageView.frame.size.width / qrImage.extent.size.width
        let scaleY = qrImageView.frame.size.height / qrImage.extent.size.height
        
        let resultQrImage = qrImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrImageView.image = UIImage(ciImage: resultQrImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
