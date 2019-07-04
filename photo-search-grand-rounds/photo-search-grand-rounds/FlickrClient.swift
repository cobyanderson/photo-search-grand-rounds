//
//  FetchPhotos.swift
//  photo-search-grand-rounds
//
//  Created by Samuel Coby Anderson on 7/2/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import Foundation
import UIKit


enum DataResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data ".localizedString
        case .decoding:
            return "An error occurred while decoding data".localizedString
        }
    }
}

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}

class FlickrClient {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func searchPhotos(text: String, page: String,
                      completion: @escaping (Result<PagedPhotoResponse, DataResponseError>) -> Void) {
        let urlRequest = URLRequest(url: URL(string:  "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=0fe1aaa149e2cd9cfae6d59c927e453f&text=\(text)&format=json&per_page=25&page=\(page)&nojsoncallback=1")!)
        
//        Adding parameter "nojsoncallback=1" to fix invalid JSON parsing errors
        
        session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
            else {
                completion(Result.failure(DataResponseError.network))
                return
            }
       
            guard let decodedResponse = try?
                JSONDecoder().decode(FullResponse.self, from: data)
                else {
                    completion(Result.failure(DataResponseError.decoding))
                    return
            }
            completion(Result.success(decodedResponse.needed_response))
        }).resume()
        
    }
    public func downloadImage(photo: Photo, is_fullsize: Bool, success: @escaping (Data) -> Void)  {
        
        var size = "q"
        if is_fullsize {size = "k"}
        
        let urlRequest = URLRequest(url: URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_\(size).jpg")!)
        
        session.dataTask(with: urlRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard let data = data else {
                return
            }
            success(data)
            
        }).resume()
    }
    
    
}

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}


extension String {
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var html2String: String {
        guard
            let data = data(using: .utf8),
            let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            else {
                return self
        }
        return attributedString.string
    }
}
