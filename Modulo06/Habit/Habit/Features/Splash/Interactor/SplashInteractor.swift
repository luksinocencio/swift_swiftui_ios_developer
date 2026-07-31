import Combine
import Foundation

class SplashInteractor {
    // private let remote: SignInRemoteDataSource = .shared
    private let local: LocalDataSource = .shared
}

extension SplashInteractor {
    func fetchAuth() -> Future<UserAuth?, Never> {
        return local.getUserAuth()
    }
}
