//
//  FlickrService.swift
//  FlickrClient
//
//  Created by Oleksandr Hozhulovskyi on 09.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit
import FlickrKit
import CoreLocation

private let resultsPerPage = "50"
private let searchRadiusKm = "1"
private let searchMediaType = "photos"

struct SearchParameters {
    var coordinate: CLLocationCoordinate2D?
    var text: String?
}

class FlickrService {
    let flickr = FlickrKit.shared()
    
    init() {
        flickr.initialize(withAPIKey: "01b6f83485cee9b24c43d6af0ccecdde", sharedSecret: "f15d38dc319a1dfc")
    }
   
    func flickrSearchParameters(parameters: SearchParameters, page: Int) -> FKFlickrPhotosSearch {
        let searchParameters = FKFlickrPhotosSearch()
        
        if let coordinate = parameters.coordinate {
            searchParameters.lat = String(coordinate.latitude)
            searchParameters.lon = String(coordinate.longitude)
        }
        
        if let text = parameters.text {
            searchParameters.text = text
        }
        
        searchParameters.per_page = resultsPerPage
        searchParameters.media = searchMediaType
        searchParameters.radius = searchRadiusKm
        searchParameters.page = String(page)
        
        return searchParameters
    }
    
    func flickrImage(from dictionary: [String: Any]) -> FlickrImage {
        let previewURL = flickr.photoURL(for: .small240, fromPhotoDictionary: dictionary)
        let largePhotoURL = flickr.photoURL(for: .large1024, fromPhotoDictionary: dictionary)
        
        return FlickrImage(previewURL: previewURL, fullURL: largePhotoURL)
    }
    
    func loadImages(by parameters: SearchParameters, onPage: Int, completionHandler: @escaping (Result<[FlickrImage], Error>) -> Void) {
        let searchParameters = flickrSearchParameters(parameters: parameters, page: onPage)
        
        flickr.call(searchParameters) { response, error in
            let result: Result<[FlickrImage], Error>
            
            if let error = error {
                result = .failure(error)
            } else if let response = response,
                let photoArray = self.flickr.photoArray(fromResponse: response) {
                let urlCollection = photoArray.map { self.flickrImage(from: $0) }
                result = .success(urlCollection)
            } else {
                result = .failure(FlickrServiceError.wrongData)
            }
            
            DispatchQueue.main.async {
                completionHandler(result)
            }   
        }
    }
}

enum FlickrServiceError: String, Error {
    case wrongData
}
