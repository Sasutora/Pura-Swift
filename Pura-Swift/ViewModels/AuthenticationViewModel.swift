//
//  AuthenticationViewModel.swift
//  Pura-Swift
//
//  Created by Rama Eka Hartono on 03/03/25.
//
import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var token: String?
    
    func login(email: String, password: String) {
        guard let url = URL(string: "\(API.baseURL)/auth/login") else {
            self.errorMessage = "Invalid URL"
            return
        }

        let body: [String: Any] = ["email": email, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response from server"
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    do {
                        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                        self.token = authResponse.token
                        self.isAuthenticated = true
                        
                        KeychainHelper.saveToken(authResponse.token)
                        UserDefaults.standard.set(authResponse.content.user.id, forKey: "userId")
                        UserDefaults.standard.set(authResponse.content.user.email, forKey: "userEmail")
                        
                    } catch {
                        self.errorMessage = "Failed to parse server response"
                    }
                } else {
                    self.errorMessage = "Invalid email or password"
                }
            }
        }.resume()
    }
    
    func logout() {
        KeychainHelper.deleteToken()
        
        // Hapus data pengguna dari UserDefaults
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        
        // Reset state authentication
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.token = nil
        }
    }
    func signUp(name: String, email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "\(API.baseURL)/auth/signup") else {
            DispatchQueue.main.async {
                completion(false, "Invalid URL")
            }
            return
        }

        let body: [String: Any] = ["nama": name, "email": email, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                    completion(false, "Network error")
                    return
                }

                if httpResponse.statusCode == 201 {
                    completion(true, "Sign up successful! Redirecting...")
                } else {
                    completion(false, "Signup failed. Try again.")
                }
            }
        }.resume()
    }

}
