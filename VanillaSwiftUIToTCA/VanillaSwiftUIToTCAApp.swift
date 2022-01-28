import SwiftUI
import Combine

#if DEBUG
extension LoginService {
    static let asyncAfter5: Self = .init(
        performLogin: { _, _ in
            Future<Void, LoginService.Error> { promise in
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 5,
                    execute: {
                        promise(.success(()))
                    }
                )
            }
            .eraseToAnyPublisher()
        }
    )

}
#endif

struct RootScene: View {
    @State var isLoggedIn: Bool = false

    var body: some View {
        if isLoggedIn {
            LoginSceneMVVM(
                viewModel: .init(
                    initialState: .init(),
                    loginService: .asyncAfter5,
                    loginDidSucceed: { isLoggedIn = false }
                )
            )
        } else {
            HomeScene(
                onLogout: { isLoggedIn = false }
            )
        }
    }
}

@main
struct VanillaSwiftUIToTCAApp: App {
    var body: some Scene {
        WindowGroup {
            RootScene()
        }
    }
}
