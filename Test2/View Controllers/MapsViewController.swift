//
//  MapsViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/19/21.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController {
    
    var locationManager: CLLocationManager!

    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(GMSServices.openSourceLicenseInfo())

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

extension MapsViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error")
    }
    
}
