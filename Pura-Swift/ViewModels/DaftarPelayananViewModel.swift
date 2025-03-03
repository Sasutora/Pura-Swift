//
//  DaftarPelayananViewModel.swift
//  Pura-Swift
//
//  Created by Rama Eka Hartono on 03/03/25.
//

import SwiftUI

import Foundation
import SwiftUI

class DaftarPelayananViewModel: ObservableObject {
    @Published var namaLengkap: String = ""
    @Published var kecamatan: String = ""
    @Published var kelurahan: String = ""
    @Published var kota: String = ""
    @Published var provinsi: String = ""
    @Published var jenisKelamin: String = "Laki-laki"
    @Published var pekerjaan: String = ""
    @Published var golonganDarah: String = "A"
    @Published var tempatLahir: String = ""
    @Published var tanggalLahir: Date = Date()
    @Published var jadwal: Date = Date()
    @Published var selectedKantorId: Int?
    @Published var kantorList: [Kantor] = []
    
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    
    @Published var selectedImage: UIImage?
    @Published var isSubmitting: Bool = false
    @Published var showSuccessAlert: Bool = false


    func fetchKantorList() {
        guard let token = KeychainHelper.getToken() else {
            self.errorMessage = "Unauthorized. Please log in."
            return
        }
        guard let url = URL(string: "\(API.baseURL)/pelayanan/kantor") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let jsonString = String(data: data, encoding: .utf8)
                        print("Response JSON: \(jsonString ?? "Invalid JSON")")
                        
                        let response = try JSONDecoder().decode(KantorResponse.self, from: data)
                        
                        self.kantorList = response.content
                        print("Updated kantorList: \(self.kantorList)")
                    } catch {
                        print("Error decoding kantor list: \(error)")
                    }
                }
            }
        }.resume()
    }



    func submitForm() {
        guard let token = KeychainHelper.getToken() else {
            self.errorMessage = "Unauthorized. Please log in."
            return
        }
        
        guard let selectedKantorId = selectedKantorId else {
            errorMessage = "Silakan pilih kantor terlebih dahulu."
            return
        }

        guard let imageData = selectedImage?.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Gambar tidak valid atau belum dipilih."
            return
        }

        isSubmitting = true
        errorMessage = nil

        let url = URL(string: "\(API.baseURL)/pelayanan/daftar")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // JSON Data
        let payload: [String: Any] = [
            "id_kantor": selectedKantorId,
            "jadwal": ISO8601DateFormatter().string(from: jadwal),
            "nama_lengkap": namaLengkap,
            "kecamatan": kecamatan,
            "kelurahan": kelurahan,
            "kota": kota,
            "provinsi": provinsi,
            "jenis_kelamin": jenisKelamin,
            "pekerjaan": pekerjaan,
            "golongan_darah": golonganDarah,
            "tempat_lahir": tempatLahir,
            "tanggal_lahir": ISO8601DateFormatter().string(from: tanggalLahir)
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"

            // Add JSON to multipart form
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"data\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(jsonString)\r\n".data(using: .utf8)!)

            // Add Image to multipart form
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            request.httpBody = body

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.isSubmitting = false
                }

                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Gagal mengirim: \(error.localizedDescription)"
                    }
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        DispatchQueue.main.async {
                            self.resetForm()
                            self.showSuccessAlert = true

                           
                        }
                    } else if let data = data,
                              let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let status = jsonResponse["status"] as? String,
                              let content = jsonResponse["content"] as? [String: Any],
                              let errorName = content["name"] as? String,
                              status == "Date Error" && errorName == "SequelizeUniqueConstraintError" {
                        DispatchQueue.main.async {
                            self.errorMessage = "Silakan pilih jadwal lain karena jadwal sudah penuh."
                            self.showErrorAlert = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Terjadi kesalahan dalam pengiriman data"
                        }
                    }
                }
            }.resume()

        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Gagal mengonversi data: \(error.localizedDescription)"
            }
        }
    }
    
    func resetForm() {
        namaLengkap = ""
        kecamatan = ""
        kelurahan = ""
        kota = ""
        provinsi = ""
        jenisKelamin = "Laki-laki"
        pekerjaan = ""
        golonganDarah = "A"
        tempatLahir = ""
        tanggalLahir = Date()
        jadwal = Date()
        selectedKantorId = nil
        selectedImage = nil
    }


}
