//
//  UIViewController+Extensions.swift
//  FlickrClient
//
//  Created by Oleksandr Hozhulovskyi on 14.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

extension UIViewController {
    func getDataError(with error: Error) {
        let alert = UIAlertController(
            title: "Error receiving photos",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
