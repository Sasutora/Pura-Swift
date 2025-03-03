//
//  ContentView.swift
//  Pura-Swift
//
//  Created by Rama Eka Hartono on 03/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthenticationViewModel()
    @StateObject var daftarPelayananViewModel = DaftarPelayananViewModel()

    var body: some View {
        NavigationView {
            Group {
                if authViewModel.isAuthenticated {
                    DashboardView()
                        .environmentObject(authViewModel)
                        .environmentObject(daftarPelayananViewModel)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}


