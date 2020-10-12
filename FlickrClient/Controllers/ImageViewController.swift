//
//  ImageViewController.swift
//  FlickrClient
//
//  Created by Oleksandr Hozhulovskyi on 13.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    let imageService = ImageService()
    var photoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        if let url = photoURL {
            imageService.imageFromURL(url) { [weak self] result in
                switch result {
                case .failure(let error): self?.getDataError(with: error)
                case .success(let image): self?.imageView.image = image;
                                          self?.imageView.bounds.size = image.size
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScale(for: view.bounds.size)
    }
    
    func updateMinZoomScale(for size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints(for: view.bounds.size)
    }
    
    func updateConstraints(for size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
}
