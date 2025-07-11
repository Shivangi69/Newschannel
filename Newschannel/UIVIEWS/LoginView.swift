import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var selectedRole: UserRole? = nil
    @State private var enteredName: String = ""
    
    var body: some View {
        
        NavigationView {
            ZStack{
                VStack(spacing: 25) {
                    // App Title
                    Text("News Panel")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 60)
                    
                    // Role Picker Dropdown
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Role")
                            .font(.headline)
                        
                        Picker("Select Role", selection: $selectedRole) {
                            Text("Select a role").tag(UserRole?.none)
                            Text("Author").tag(UserRole.author)
                            Text("Reviewer").tag(UserRole.reviewer)
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Name TextField
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter Name")
                            .font(.headline)
                        
                        TextField("Enter your name", text: $enteredName)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Login Button
                    Button(action: {
                        if let role = selectedRole, !enteredName.trimmingCharacters(in: .whitespaces).isEmpty {
                            viewModel.login(with: role, username: enteredName)
                        } else {
                            viewModel.showAlertWith(message: "Please select a role and enter your name.")
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(canLogin ? Color.accentColor : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .disabled(!canLogin)
                    .background(
                        Group {
                            if let user = viewModel.sessionManager.getUser() {
                                NavigationLink(
                                    destination: destinationView(for: UserRole(rawValue: user.role.rawValue) ?? .reviewer),
                                    isActive: $viewModel.isLoggedIn
                                ) {
                                    EmptyView()
                                }
                                .hidden()
                            }
                        }
                    )

                    
                    Spacer()
                    
                    // Sync Button
                    Button(action: {
                        viewModel.syncData()
                    }) {
                        Text("Sync")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color(.systemGray5))
                            .foregroundColor(.accentColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 40)
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Notice"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
            


            }
            .onAppear {
                viewModel.startAutoSync()
            }
            .onDisappear {
                viewModel.stopAutoSync()
            }
            .background(
                     LinearGradient(
                         gradient: Gradient(colors: [Color.blue, Color.purple]),
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing
                     )
                     .ignoresSafeArea()
                 )
                 .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
    
    // Enable Login only if role + name are set
    var canLogin: Bool {
        selectedRole != nil && !enteredName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func destinationView(for role: UserRole) -> some View {
        switch role {
        case .author:
            return AnyView(AuthorNewsListView())
        case .reviewer:
            return AnyView(NewsListView())
        }
    }


}
