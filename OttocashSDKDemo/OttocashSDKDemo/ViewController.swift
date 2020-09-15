//
//  ViewController.swift
//  OttocashSDKDemo
//
//  Created by Clapping Ape on 16/05/19.
//  Copyright © 2019 Nur Choirudin. All rights reserved.
//

import UIKit

import UIKit
import OTTOCashSDK
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var widgetView: UIView!
    var test : OTTOCashSDKManager? = nil
    var locationManager:CLLocationManager!
    var coordinate: CLLocationCoordinate2D!
    @IBOutlet weak var balanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test = OTTOCashSDKManager.shared
        test?.setupClient(id: "f04e0a8a7a129b42d3089ebb68bc3c09671c0f23d1ee2a25a996883823844d60", secret: "a136e35b69881a9496a14d2652976c72054cf18ae57ffb7461263a41bf3f2866")
        test?.setDebugMode(true)
        let userLocation:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        test!.userIdentity(name: "iLotte", location: userLocation.coordinate, phone: "085659791134")
        test?.paymentDelegate = self
        DispatchQueue.main.async {
            self.test!.addWidget(self.widgetView)}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
        
        OTTOCashSDKManager.shared.refresh(completion: {
            DispatchQueue.main.async {
                self.balanceLabel.text = OTTOCashSDKManager.shared.userDetails.emoney_balance
            }
        }) { (error) in
            
        }
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        test!.userIdentity(name: "iLotte", location: userLocation.coordinate, phone: "085659791134")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    @IBAction func openQR(_ sender: Any) {
        OTTOCashSDKManager.shared.navigationManager.openMenu(menu: .qrCode, onViewController: self)
    }
    @IBAction func openTopup(_ sender: Any) {
        OTTOCashSDKManager.shared.navigationManager.openMenu(menu: .topup, onViewController: self)
    }
    @IBAction func openHistory(_ sender: Any) {
        OTTOCashSDKManager.shared.navigationManager.openMenu(menu: .transactionHistory, onViewController: self)
    }
    
    @IBAction func p2pAction(_ sender: Any) {
        OTTOCashSDKManager.shared.navigationManager.openMenu(menu: .transferp2p, onViewController: self)
    }
}

extension ViewController: OCPaymentDelegate{
    func didTransferSuccess(){
        let alertController = UIAlertController(title: "Alert", message: "SUCCESS", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
