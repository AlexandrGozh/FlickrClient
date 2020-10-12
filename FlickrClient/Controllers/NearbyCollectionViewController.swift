//
//  NearbyCollectionViewController.swift
//  FlickrClient
//
//  Created by Oleksandr Hozhulovskyi on 30.04.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit
import CoreLocation

struct FlickrImage {
    let previewURL: URL
    let fullURL: URL
}

class NearbyCollectionViewController: PhotosCollectionViewController {
    var locationService: LocationService!
    let flickrService = FlickrService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService = LocationService(delegate: self)
    }

    override func loadPhotos() {
        if let coordinate = locationService.coordinate {
            didUpdateCoordinate(coordinate)
        }
    }
}

extension NearbyCollectionViewController: LocationServiceDelegate {
    func didUpdateCoordinate(_ coordinate: CLLocationCoordinate2D) {
        flickrService.loadImages(by: SearchParameters(coordinate: coordinate), onPage: urlsPage) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.getDataError(with: error)
            case .success(let urls):
                self?.urlCollection.append(contentsOf: urls);
                self?.collectionView.reloadData()
            }
        }
    }
    
    func accessDenied() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "This app needs your location to show photos near with you. Please, enable location services in Settings.",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
