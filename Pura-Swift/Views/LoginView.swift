//
//  LoginView.swift
//  Pura-Swift
//
//  Created by Rama Eka Hartono on 03/03/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    Button("Login") {
                        authViewModel.login(email: email, password: password)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    NavigationLink("Sign Up", destination: SignUpView().environmentObject(authViewModel))

                        .padding()
                }
                .padding()
                .frame(minHeight: geometry.size.height)
            }
            .scrollDismissesKeyboard(.interactively)
            .ignoresSafeArea(.keyboard)
        }
    }
}
