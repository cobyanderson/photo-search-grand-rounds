//
//  ViewController.swift
//  photo-search-grand-rounds
//
//  Created by Samuel Coby Anderson on 7/2/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, PhotosViewModelDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UICollectionViewDataSourcePrefetching  {

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let itemsPerRow: CGFloat = 3
    private let paddingPerItem: CGFloat = 5
    
    private var viewModel: PhotosViewModel!
    
    private var selectedPhoto: Photo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        collectionView.prefetchDataSource = self
        
        viewModel = PhotosViewModel(delegate: self)

        viewModel.fetchPhotos()
        
        
    }
    // Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.setSearchText(text: searchBar.text ?? "")
        viewModel.clearPhotos()
        collectionView.reloadData()
        viewModel.fetchPhotos()
    }
    // Prefetching
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchPhotos()
        }
    }
    
    // View Model Delegate
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        // 1
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.isHidden = false
            collectionView.reloadData()
            return
        }
        // 2
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
    }
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    // Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCount
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.ImageAt(index: indexPath.row))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoData = viewModel.ImageAt(index: indexPath.row).photo
        
        guard
            let storyboard = self.storyboard,
            let vc = storyboard.instantiateViewController(withIdentifier: "FullsizeViewController") as? FullsizeViewController
            else {return}
        
        
        vc.photo = photoData
        present(vc, animated: true)

    }
    
    // Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = paddingPerItem * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
}



