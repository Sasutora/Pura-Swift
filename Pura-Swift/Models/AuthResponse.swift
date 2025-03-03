//
//  AuthResponse.swift
//  Pura-Swift
//
//  Created by Rama Eka Hartono on 03/03/25.
//

import Foundation

struct AuthResponse: Codable {
    let status: String
    let content: Content
    let token: String

    struct Content: Codable {
        let message: String
        let user: User
    }

    struct User: Codable {
        let id: Int
        let email: String
    }
}
