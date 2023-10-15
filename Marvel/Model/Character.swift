//
//  Character.swift
//  Marvel
//
//  Created by Luis Sergio Duran Arenas on 06/10/23.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let description: String
    let modified: String
    let resourceURI: String
    let thumbnail: Image
    let urls: [UrlWebsite]
    let comics: ResourceList<Comic>
    let stories: ResourceList<Story>
    let events: ResourceList<Event>
    let series: ResourceList<Serie>
}
