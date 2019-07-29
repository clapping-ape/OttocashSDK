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
        otto?.setupClient(id: "f04e0a8a7a129b42d3089ebb68bc3c09671c0f23d1ee2a25a996883823844d60", secret: "a136e35b69881a9496a14d2652976c72054cf18ae57ffb7461263a41bf3f2866")
        otto?.setDebugMode(true)
        let userLocation:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        otto?.userIdentity(name: "iLotte", location: userLocation.coordinate, phone: "085659791134")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        otto?.addWidget(widgetView)
    }

}

