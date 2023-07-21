import SwiftUI
import Firebase

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @FocusState private var isEmailFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isConfirmPasswordFocused: Bool
    
    @State private var signupError: String?
    @State private var signupSuccess: Bool = false
    
    @State private var showLoginPage = false;

    var body: some View {
        
        if showLoginPage {
            LoginView()
        }
        
        else {
            content
        }
        
    }
    
    var content: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.6)
                        .padding(.top, 30)

                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .focused($isEmailFocused)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .accentColor(.black)
                            .padding(.horizontal, 20)
                            .font(.headline)
                            .autocapitalization(.none)

                        SecureField("Password", text: $password)
                            .focused($isPasswordFocused)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .accentColor(.black)
                            .padding(.horizontal, 20)
                            .font(.headline)
                            .autocapitalization(.none)
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .focused($isConfirmPasswordFocused)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .accentColor(.black)
                            .padding(.horizontal, 20)
                            .font(.headline)
                            .autocapitalization(.none)
                    }
                    .padding(.vertical, 20)

                    Button(action: {
                        print("Signup Button Clicked")
                        signUp()
                    }) {
                        Text("Signup")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 10)
                    
                    Button(action: {showLoginPage = true}) {
                        Text("Login").foregroundColor(Color.white).underline()
                    }
                    
                    if let signupError = signupError {
                                        Text(signupError)
                                            .foregroundColor(.red)
                                            .padding(.vertical, 5)
                                    }
                }
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: Binding.constant(signupError != nil)) {
            Alert(title: Text("Error"), message: Text(signupError!), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: Binding.constant(signupSuccess)) {
            Alert(title: Text("Success"), message: Text("Signup successful! An email verification link has been sent."), dismissButton: .default(Text("OK")))
        }
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [self] result, error in
            if let error = error as NSError? {
                signupError = error.localizedDescription
                signupSuccess = false
            } else {
                signupError = nil
                signupSuccess = true
                sendEmailVerification()
            }
        }
    }
    
    func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification { error in
            if let error = error as NSError? {
                print("Error sending email verification:", error.localizedDescription)
            } else {
                print("Email verification sent.")
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
