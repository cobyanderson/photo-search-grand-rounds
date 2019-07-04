//
//  FlickrClient.swift
//  photo-search-grand-rounds
//
//  Created by Samuel Coby Anderson on 7/2/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import Foundation
import UIKit


class FlickrClient {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func searchPhotos(text: String, page: String,
                      success: @escaping (PagedPhotoResponse) -> Void) {

        let urlRequest = URLRequest(url: URL(string:  "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=0fe1aaa149e2cd9cfae6d59c927e453f&text=\(text)&format=json&per_page=25&page=\(page)&nojsoncallback=1&safe_search=1")!)
//        Adding parameter "nojsoncallback=1" to fix invalid JSON parsing errors
//        Adding parameter "safe_search=1" to avoid pornography
        
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                return
            }
       
            guard let decodedResponse = try?
                JSONDecoder().decode(FullResponse.self, from: data)
                else {
                    return
            }
            success(decodedResponse.needed_response)
        }).resume()
        
    }
    public func downloadImage(photo: Photo, is_fullsize: Bool, success: @escaping (Data) -> Void)  {
        
        var size = "q"
        if is_fullsize {size = "c"}
        
        let urlRequest = URLRequest(url: URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_\(size).jpg")!)
        
        session.dataTask(with: urlRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard let data = data else {
                return
            }
            success(data)
            
        }).resume()
    }
}
