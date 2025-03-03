//
//  DetailPelayananView.swift
//  Pura-Swift
//
//  Created by Rama Eka Hartono on 04/03/25.
//
import SwiftUI

struct DetailPelayananView: View {
    let pelayanan: PelayananResponse
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Foto Profil
                AsyncImage(url: URL(string: "\(API.baseURL)/\(pelayanan.foto)")) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
                .padding(.bottom, 10)
                
                Text(pelayanan.nama_lengkap)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Kode: \(pelayanan.kode)")
                    .font(.title3)
                
                Text("Jenis Kelamin: \(pelayanan.jenis_kelamin)")
                    .font(.title3)
                
                Text("Pekerjaan: \(pelayanan.pekerjaan)")
                    .font(.title3)
                
                Text("Golongan Darah: \(pelayanan.golongan_darah)")
                    .font(.title3)
                
                Text("Tempat Lahir: \(pelayanan.tempat_lahir)")
                    .font(.title3)
                
                Text("Tanggal Lahir: \(pelayanan.tanggal_lahir)")
                    .font(.title3)
                
                Text("Alamat: \(pelayanan.kelurahan), \(pelayanan.kecamatan), \(pelayanan.kota), \(pelayanan.provinsi)")
                    .font(.title3)
                
                Text("Kantor: \(pelayanan.kantor.nama)")
                    .font(.title2)
                    .foregroundColor(.gray)
                
                Text("Jadwal: \(pelayanan.jadwal)")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                // QR Code
                AsyncImage(url: URL(string: "\(API.baseURL)/\(pelayanan.qr_code)")) { image in
                    AsyncImage(url: URL(string: "\(API.baseURL)/\(pelayanan.qr_code)")) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.top, 10)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Detail Pelayanan")
        }
        
    }
}
