import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    // Onboarding flag stored in UserDefaults
    @AppStorage("hasSeenHowToPlay") private var hasSeenHowToPlay: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Giriş Yap")
                .font(.title).bold()

            TextField("E-posta", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .padding().background(Color(.systemGray6)).cornerRadius(8)

            SecureField("Şifre", text: $password)
                .padding().background(Color(.systemGray6)).cornerRadius(8)

            Button("Giriş Yap") {
                hasSeenHowToPlay = true   // Skip onboarding for returning users
                authVM.login(email: email, password: password)
            }
            .disabled(email.isEmpty || password.isEmpty)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Kayıt Ol") {
                hasSeenHowToPlay = false  // Show onboarding right after sign‑up
                authVM.signUp(email: email, password: password)
            }

            if !authVM.errorMessage.isEmpty {
                Text(authVM.errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
        
    }
}
