import SwiftUI
import Firebase
struct LoginView: View {
   
    @State private var email: String = ""
       @State private var password: String = ""
       
       @FocusState private var isEmailFocused: Bool
       @FocusState private var isPasswordFocused: Bool
       
       @State private var emailError: String?
       @State private var passwordError: String?
       
       @State private var showSignUpPage = false;
       @State private var isEmailVerified = false;
    
       @AppStorage("userIsLoggedIn") private var userIsLoggedIn = false

    
    
       var body: some View {
           if userIsLoggedIn {
               ContentView()
           }
           else if showSignUpPage {
               SignupView()
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
                        .frame(width: geometry.size.width * 0.6) // Adjust the multiplier as needed
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

                        if let emailError = emailError {
                            Text(emailError)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                        }

                        SecureField("Password", text: $password)
                            .focused($isPasswordFocused) // Set focus state for the password TextField
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .accentColor(.black)
                            .padding(.horizontal, 20)
                            .font(.headline)
                            .autocapitalization(.none)

                        if let passwordError = passwordError {
                            Text(passwordError)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                        }
                    }
                    .padding(.vertical, 20)

                    Button(action: {
                        print("Login Button Clicked")
                        login()
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 10)
                    
                    Button(action: {showSignUpPage = true}) {
                        Text("Signup").foregroundColor(Color.white).underline()
                    }
                    
                }
                
                
            }
        }
        .navigationBarHidden(true)
    }
    
    

    func login() {
            // Reset previous error messages
            emailError = nil
            passwordError = nil
        
        if Auth.auth().currentUser?.isEmailVerified == false {
            emailError = "Email not verified."
        }
        else {
            isEmailVerified = true;
        }
            
            Auth.auth().signIn(withEmail: email, password: password) {
                
                [self] result, error in
                if let error = error as NSError? {
                    switch error.code {
                    case AuthErrorCode.wrongPassword.rawValue:
                        passwordError = "Wrong password. Please try again."
                        emailError = nil
                    case AuthErrorCode.invalidEmail.rawValue, AuthErrorCode.userNotFound.rawValue:
                        emailError = "Wrong email. Please check your email and try again."
        
                        
                    default:
                        print(error.localizedDescription)
                    }
                    // Set userIsLoggedIn to false if there are errors
                    userIsLoggedIn = false
                } else {
                    // No error, user is logged in successfully
                    if isEmailVerified {
                        userIsLoggedIn = true
                    }
                    
                }
            }
        
        
                    
                    
        }
    
    }



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
