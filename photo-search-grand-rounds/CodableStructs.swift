//
//  CodableStructs.swift
//  photo-search-grand-rounds
//
//  Created by Samuel Coby Anderson on 7/2/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import Foundation
import UIKit


struct Photo: Decodable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case server
        case farm
    }
    
}
struct FullResponse: Decodable {
    let needed_response: PagedPhotoResponse
    
    enum CodingKeys: String, CodingKey {
        case needed_response = "photos"
    }
}

struct PagedPhotoResponse: Decodable {
    let photos: [Photo]
    let page: Int
    let total: String
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
        case page
        case total
    }
    
}
