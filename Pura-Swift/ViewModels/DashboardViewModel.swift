import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var pelayanans: [PelayananResponse] = []
    @Published var errorMessage: String?
        @Published var pelayananDetail: PelayananResponse?
    
    func fetchPelayanans() {
        guard let token = KeychainHelper.getToken() else {
            self.errorMessage = "Unauthorized. Please log in."
            print("Error: Token tidak tersedia")
            return
        }
        
        guard let url = URL(string: "\(API.baseURL)/pelayanan/user") else {
            self.errorMessage = "Invalid URL"
            print("Error: URL tidak valid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    print("Network error:", error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    print("Error: Tidak ada data yang diterima")
                    return
                }
                
                do {

                    let decoder = JSONDecoder()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    decoder.dateDecodingStrategy = .formatted(formatter)

                    let response = try decoder.decode(PelayananAPIResponse.self, from: data)
                    self.pelayanans = response.content
                } catch {
                    self.errorMessage = "Failed to decode JSON: \(error.localizedDescription)"
                    print("Error decoding JSON:", error)
                }


            }
        }.resume()
    }
    func fetchPelayanan(kode: String) {
            guard let token = KeychainHelper.getToken() else {
                return
            }
            
            guard let url = URL(string: "\(API.baseURL)/pelayanan/kode/\(kode)") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601 // Menyesuaikan format tanggal

                do {
                    let apiResponse = try decoder.decode(APIResponse<PelayananResponse>.self, from: data)
                    DispatchQueue.main.async {
                        self.pelayananDetail = apiResponse.content
                    }
                } catch {
                    print("Error decoding response: \(error.localizedDescription)")
                }
            }.resume()
        }
}
