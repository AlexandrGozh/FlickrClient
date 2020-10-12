//
//  ReusableCollectionViewCell.swift
//  FlickrClient
//
//  Created by Oleksandr Hozhulovskyi on 30.04.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    let imageService = ImageService()
    var url: URL? {
        didSet {
            guard let url = url else { return }

            imageService.imageFromURL(url) { [weak self] result in
                switch result {
                case .failure(let error): print("Error: \(error)")
                case .success(let image): self?.imageView.image = image
                }
            }
        }
    }

    override func prepareForReuse() {
        imageView.image = nil

        guard let url = url else { return }

        imageService.stopLoadImage(from: url)
    }
}
