//
//  UserModel.swift
//  QRTrainerTruckAdminApp
//
//  Created by Koplányi Dávid on 2021. 11. 11..
//

import Foundation

struct UserModel: Codable {
    
    let id: String
    let name: String
    let mobile: String
    let rank: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case mobile
        case rank
    }
}
