//
//  LocationService.swift
//  FlickrClient
//
//  Created by Oleksandr Hozhulovskyi on 10.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func didUpdateCoordinate(_ coordinate: CLLocationCoordinate2D)
    func accessDenied()
}

class LocationService: NSObject {
    private let kOneKilometer: Double = 1000
    weak var delegate: LocationServiceDelegate?
    var coordinate: CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }

    let locationManager: CLLocationManager
   
    init(delegate: LocationServiceDelegate) {
        locationManager = CLLocationManager()
        self.delegate = delegate
        
        super.init()
        
        locationManager.delegate = self
        locationManager.distanceFilter = kOneKilometer
        locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        delegate?.didUpdateCoordinate(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .denied, .restricted:
            delegate?.accessDenied()
            break
        default:
            break
        }
    }
}
