//
//  SearchCollectionViewController.swift
//  FlickrClient
//
//  Created by Oleksandr Hozhulovskyi on 14.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

private let searchBarReuseIdentifier = "SearchBar"

class SearchCollectionViewController: PhotosCollectionViewController {
    let flickrService = FlickrService()
    private var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
    }

    override func loadPhotos() {
        searchImages(with: searchText, onPage: urlsPage)
    }

    func searchImages(with text: String, onPage: Int) {
        flickrService.loadImages(by: SearchParameters(text: text), onPage: urlsPage) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.getDataError(with: error)
            case .success(let urls):
                self?.urlCollection.append(contentsOf: urls);
                self?.collectionView.reloadData()
            }
        }
    }
}

extension SearchCollectionViewController: UISearchBarDelegate {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: searchBarReuseIdentifier, for: indexPath)
        
        return searchView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" else { return }

        view.endEditing(true)
        urlCollection.removeAll()
        collectionView.reloadData()
        searchText = text
        urlsPage = 1
        searchImages(with: text, onPage: urlsPage)
    }
}
