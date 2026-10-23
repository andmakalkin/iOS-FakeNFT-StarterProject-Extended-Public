import Foundation

@Observable
@MainActor
final class ServicesAssembly {

    let userDefaultsService: UserDefaultsServiceProtocol
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService()
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.userDefaultsService = userDefaultsService
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
}
