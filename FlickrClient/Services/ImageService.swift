//
//  ImageService.swift
//  FlickrClient
//
//  Created by Oleksandr Hozhulovskyi on 11.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

class ImageService {
    private var dataTaskCollection: [URL: URLSessionDataTask] = [:]

    func imageFromURL(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            let result: Result<UIImage, Error>
            DispatchQueue.main.sync {
                self.dataTaskCollection[url] = nil
            }

            if let error = error {
                guard (error as NSError).code != NSURLErrorCancelled else { return }

                result = .failure(error)
            } else if let data = data,
                let image = UIImage(data: data) {
                result = .success(image)
            } else {
                result = .failure(ImageServiceError.wrongData)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }  
        }
        dataTask.resume()
        dataTaskCollection[url] = dataTask
    }

    func stopLoadImage(from url: URL) {
        guard let task = dataTaskCollection[url] else { return }

        task.cancel()
    }
}

enum ImageServiceError: String, Error {
    case wrongData
}
