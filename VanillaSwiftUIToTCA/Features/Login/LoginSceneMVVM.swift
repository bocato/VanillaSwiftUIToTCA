import SwiftUI
import Combine




extension LoginViewModel {
    struct State {
        var user: String = ""
        var password: String = ""
        var errorMessage: String?
        var isLoading: Bool = false
    }
}

final class LoginViewModel: ObservableObject {
    // MARK: - Dependencies

    private let mainQueue: DispatchQueue
    private let loginService: LoginService
    private let loginDidSucceed: () -> Void

    // MARK: - Properties

    @Published var state: State
    private var subscriptions: Set<AnyCancellable> = .init()

    // MARK: - Initialization

    init(
        initialState: State,
        mainQueue: DispatchQueue = .main,
        loginService: LoginService,
        loginDidSucceed: @escaping () -> Void
    ) {
        self.state = initialState
        self.mainQueue = mainQueue
        self.loginService = loginService
        self.loginDidSucceed = loginDidSucceed
    }

    // MARK: - Public API

    func performLogin() {
        state.errorMessage = nil
        state.isLoading = true

        let user = state.user
        let password = state.password

        loginService
            .performLogin(user, password)
            .receive(on: mainQueue)
            .sink {
                if case let .failure(error) = $0 {
                    self.state.errorMessage = error.rawValue
                }
                self.state.isLoading = false
            } receiveValue: { [loginDidSucceed] _ in
                self.state.isLoading = false
                loginDidSucceed()
            }
            .store(in: &subscriptions)
    }
}

struct LoginSceneMVVM: View {
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack {
            Text("Login")
                .bold()
                .font(.largeTitle)
            
            Spacer()
            makeErrorViewIfPossible(viewModel.state.errorMessage)
            if viewModel.state.isLoading {
                ActivityIndicator()
            } else {
                VStack {
                    TextField(
                        "User",
                        text: .init(
                            get: { viewModel.state.user },
                            set: { newValue in
                                viewModel.state.user = newValue
                            }
                        )
                    )
                    .frame(height: 44)
                    .border(Color.black)
                    .padding()
                    
                    SecureField(
                        "Password",
                        text: .init(
                            get: { viewModel.state.password },
                            set: { newValue in
                                viewModel.state.password = newValue
                            }
                        )
                    )
                    .frame(height: 44)
                    .border(Color.black)
                    .padding()
                }
                .padding(.all, 10)
                
                Button(
                    "Login",
                    action: viewModel.performLogin
                )
            }
            
            Spacer()
        }
    }
    @ViewBuilder
    private func makeErrorViewIfPossible(_ errorMessage: String?) -> some View {
        if let errorMessage = errorMessage {
            ErrorView(
                title: errorMessage,
                action: viewModel.performLogin
            )
        }
    }
}

#if DEBUG
struct LoginViewMVVM_Previews: PreviewProvider {
    static var previews: some View {
        LoginSceneMVVM(
            viewModel: .init(
                initialState: .init(),
                loginService: .asyncAfter5,
                loginDidSucceed: { print("loginDidSucceed") }
            )
        )
    }
}
#endif
