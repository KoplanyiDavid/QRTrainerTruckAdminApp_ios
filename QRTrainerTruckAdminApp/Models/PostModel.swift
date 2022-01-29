//
//  PostModel.swift
//  QRTrainerTruckAdminApp
//
//  Created by Koplányi Dávid on 2021. 11. 14..
//

import Foundation

struct PostModel: Codable {
    
    let authorId: String
    let authorName: String
    let imageUrl: URL
    let title: String
    let description: String
    let sorter: UInt64
    
    enum CodingKeys: String, CodingKey {
        case authorId
        case authorName
        case imageUrl
        case title
        case description
        case sorter
    }
}
