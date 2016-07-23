//
//  ViewController.swift
//  CoreLocationExample
//
//  Created by Matthew Tso on 7/22/16.
//  Copyright © 2016 Matthew Tso. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        geocoder.geocodeAddressString("San Jose State University", completionHandler: {
            (placemarks: [CLPlacemark]?, error: NSError?) in
            
            if error != nil {
                print(error)
                return
            }
            
            for placemark in placemarks! {
                print(placemark)
            }
//            if placemarks != nil && placemarks!.count > 0 {
//                
//            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

