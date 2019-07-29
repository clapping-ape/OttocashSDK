//
//  ViewController.swift
//  OttocashSDKDemo
//
//  Created by Clapping Ape on 16/05/19.
//  Copyright © 2019 Nur Choirudin. All rights reserved.
//

import UIKit
import OTTOCashSDK
import CoreLocation

class ViewController: UIViewController {
    var otto : OTTOCashSDKManager? = nil
    
    @IBOutlet weak var widgetView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otto = OTTOCashSDKManager.shared
        otto?.setupClient(id: "CLIENT_ID", secret: "CLIENT_SECRET")
        let userLocation:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        otto?.userIdentity(name: "[APP_NAME]", location: userLocation.coordinate, phone: "[PHONE NUMBER]")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        otto?.addWidget(widgetView)
    }

}

