//
//  PhotosViewModel.swift
//  photo-search-grand-rounds
//
//  Created by Samuel Coby Anderson on 7/2/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import Foundation
import UIKit

protocol PhotosViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
}

final class PhotosViewModel {
    private weak var delegate: PhotosViewModelDelegate?
    private var images: [Image] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    private var searchText = ""
    
    let client = FlickrClient()
    
    init(delegate: PhotosViewModelDelegate) {
        self.delegate = delegate
    }
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return images.count
    }
    
    func ImageAt(index: Int) -> Image {
        return images[index]
    }
    func setSearchText(text: String) {
        self.searchText = text
    }
    func clearPhotos() {
        self.images = []
        self.total = 0
        self.currentPage = 1
    }
    
    func fetchPhotos() {
        
        guard !isFetchInProgress, self.searchText != "" else {
            return
        }
        
        isFetchInProgress = true
        
        client.searchPhotos(text: self.searchText, page: String(currentPage)) { response in
            
            DispatchQueue.main.async {

                self.currentPage += 1
                self.isFetchInProgress = false
                // Sets a maximum of 1000 photos per search
                self.total = [1000, Int(response.total) ?? 0].min() ?? 0
                
                print(self.total)
                
                for photo in response.photos {
                    self.images.append(Image(photo: photo))
                }
                for (i, image) in self.images.enumerated() {
                    self.fetchThumbnail(image: image, index: i)
                }
                
                if response.page > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(with: response.photos.count)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self.delegate?.onFetchCompleted(with: .none)
                    
                }
            }
        }
    }
    
    func fetchThumbnail(image: Image, index: Int) {
        client.downloadImage(photo: image.photo, is_fullsize: false) { (data) in
            
            DispatchQueue.main.async {
                image.thumbnail = UIImage(data: data)
                self.delegate?.onFetchCompleted(with: [IndexPath(row: index, section: 0)])
            }
        }
    }
    
    
    private func calculateIndexPathsToReload(with newCount: Int) -> [IndexPath] {
        let startIndex = images.count - newCount
        let endIndex = startIndex + newCount
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0)}
    }
    
}
