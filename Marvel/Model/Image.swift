//
//  Image.swift
//  Marvel
//
//  Created by Luis Sergio Duran Arenas on 06/10/23.
//

import Foundation

struct Image: Codable {
    let path: String
    let fileExtension: String
    
    var url: String {
        return path + "." + fileExtension
    }
    
    enum CodingKeys : String, CodingKey{
        case path = "path"
        case fileExtension = "extension"
    }
}
