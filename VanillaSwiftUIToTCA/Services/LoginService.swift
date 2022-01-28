import Foundation
import Combine

struct LoginService {
    enum Error: String, Swift.Error {
        case ohShit
    }
    let performLogin: (_ user: String, _ password: String) -> AnyPublisher<Void, Error>
}

#if DEBUG
extension LoginService {
    static let success: Self = .init(
        performLogin: { _, _ in
            Just<Void>(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    )

    static let failure: Self = .init(
        performLogin: { _, _ in
            Fail<Void, Error>(error: .ohShit)
                .eraseToAnyPublisher()
        }
    )
}
#endif
