//
//  FullsizeViewController.swift
//  photo-search-grand-rounds
//
//  Created by Samuel Coby Anderson on 7/3/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import Foundation
import UIKit

class FullsizeViewController: UIViewController {
    
    var photo: Photo? = nil
    
    let client = FlickrClient()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: {
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        guard let photo = photo else { return }
        
        client.downloadImage(photo: photo, is_fullsize: true) { (data) in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.imageView.image = UIImage(data: data)
                
            }
        }
        
    }
}
