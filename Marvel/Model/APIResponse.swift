//
//  APIResponse.swift
//  Marvel
//
//  Created by Luis Sergio Duran Arenas on 06/10/23.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let code: Int
    let status: String
    let copyright: String
    let attributionText: String
    let attributionHTML: String
    let etag: String
    let data: DataResponse<T>
}
