//
//  Kantor.swift
//  Pura-Swift
//
//  Created by Rama Eka Hartono on 03/03/25.
//
import Foundation
struct Kantor: Identifiable, Codable {
    let id: Int
    let nama: String
}

struct KantorResponse: Codable {
    let status: String
    let content: [Kantor]
}
