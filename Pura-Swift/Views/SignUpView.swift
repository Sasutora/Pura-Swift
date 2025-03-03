import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Sign Up") {
                authViewModel.signUp(name: name, email: email, password: password) { success, message in
                    alertMessage = message
                    showAlert = true
                    
                    if success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Sign Up"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
    }
}
