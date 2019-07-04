//
//  CollectionViewCell.swift
//  photo-search-grand-rounds
//
//  Created by Samuel Coby Anderson on 7/3/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.hidesWhenStopped = true
    }
    
    func configure(with image: Image?) {
        guard
            let image = image,
            let thumbnail = image.thumbnail
            else {
                activityIndicator.startAnimating()
                self.imageView.image = nil
                return
        }
        imageView.image = thumbnail
        activityIndicator.stopAnimating()
        
    }
}
