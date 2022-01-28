//
//  LoginSceneTCA.swift
//  VanillaSwiftUIToTCA
//
//  Created by Bocato, Eduardo on 28/01/2022.
//

import SwiftUI
import ComposableArchitecture

struct LoginSceneTCAState: Equatable {
    var user: String = ""
    var password: String = ""
    var errorMessage: String?
    var isLoading: Bool = false
}

enum LoginSceneTCAAction {
    case updateUsername(String)
    case updatePassword(String)
    case performLoginButtonTapped
}

typealias LoginSceneTCAReducer = Reducer<LoginSceneTCAState, LoginSceneTCAAction, LoginSceneTCAEnvironment>

let loginReducer: LoginSceneTCAReducer = .init { state, action, env in

    switch action {
    case let .updateUsername(username):
        state.user = username
        return .none

    case let .updatePassword(password):
        state.password = password
        return .none

    case .performLoginButtonTapped:
        return .none

    }

}

struct LoginSceneTCAEnvironment {

}

typealias LoginSceneTCAViewStore = Store<LoginSceneTCAState, LoginSceneTCAAction>

struct LoginSceneTCAView: View {
    @StateObject var viewModel: LoginViewModel

    let store: LoginSceneTCAViewStore

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text("Login")
                    .bold()
                    .font(.largeTitle)

                Spacer()
                makeErrorViewIfPossible(viewStore.errorMessage)
                if viewStore.state.isLoading {
                    ActivityIndicator()
                } else {
                    VStack {
                        TextField(
                            "User",
                            text: viewStore.binding(
                                get: \.user,
                                send: LoginSceneTCAAction.updateUsername
                            )
                        )
                        .frame(height: 44)
                        .border(Color.black)
                        .padding()

                        SecureField(
                            "Password",
                            text: viewStore.binding(
                                get: \.password,
                                send: LoginSceneTCAAction.updatePassword
                            )
                        )
                        .frame(height: 44)
                        .border(Color.black)
                        .padding()
                    }
                    .padding(.all, 10)

                    Button(
                        "Login",
                        action: { viewStore.send(.performLoginButtonTapped) }
                    )
                }

                Spacer()
            }
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
