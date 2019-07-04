//
//  ImageClass.swift
//  photo-search-grand-rounds
//
//  Created by Samuel Coby Anderson on 7/3/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import Foundation
import UIKit

public class Image {
    let photo: Photo
    var thumbnail: UIImage?
    var fullsize: UIImage?
    
    init(photo: Photo) {
        self.photo = photo
        self.thumbnail = nil
        self.fullsize = nil
    }
}
