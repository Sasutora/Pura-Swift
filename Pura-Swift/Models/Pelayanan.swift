//
//  Pelayanan.swift
//  Pura-Swift
//
//  Created by Rama Eka Hartono on 03/03/25.
//

import Foundation

struct Pelayanan: Identifiable, Codable {
    let id: Int
    let kode: String
    let nama_lengkap: String
    let kecamatan: String
    let kelurahan: String
    let kota: String
    let provinsi: String
    let jenis_kelamin: String
    let pekerjaan: String
    let golongan_darah: String
    let tempat_lahir: String
    let tanggal_lahir: String
    let foto: String
    let jadwal: String
    let kantor: Kantor
}


struct PelayananResponse: Identifiable, Codable {
    let id: Int
    let kode: String
    let id_user: Int
    let nama_lengkap: String
    let kecamatan: String
    let kelurahan: String
    let kota: String
    let provinsi: String
    let jenis_kelamin: String
    let pekerjaan: String
    let golongan_darah: String
    let tempat_lahir: String
    let tanggal_lahir: String
    let foto: String
    let id_kantor: Int
    let jadwal: String
    let qr_code: String
    let kantor: Kantor

    enum CodingKeys: String, CodingKey {
        case id, kode, id_user, nama_lengkap, kecamatan, kelurahan, kota, provinsi, pekerjaan,
             golongan_darah, tempat_lahir, foto, qr_code, id_kantor
        case jenis_kelamin = "jenis_kelamin"
        case tanggal_lahir = "tanggal_lahir"
        case jadwal = "jadwal"
        case kantor = "Kantor" 
    }
}

struct PelayananAPIResponse: Codable {
    let status: String
    let content: [PelayananResponse]
}

struct APIResponse<T: Codable>: Codable {
    let status: String
    let content: T
}
