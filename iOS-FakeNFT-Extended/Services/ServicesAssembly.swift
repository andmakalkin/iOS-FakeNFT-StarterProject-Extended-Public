import Foundation

@Observable
@MainActor
final class ServicesAssembly {

    let userDefaultsService: UserDefaultsServiceProtocol
    let collectionService: CollectionServiceProtocol
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService(),
        collectionService: CollectionServiceProtocol? = nil
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.userDefaultsService = userDefaultsService
        self.collectionService = collectionService ?? CollectionService(networkClient: networkClient)
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
}
