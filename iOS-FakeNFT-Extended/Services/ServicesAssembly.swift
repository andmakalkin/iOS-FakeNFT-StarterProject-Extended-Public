import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    let userDefaultsService: UserDefaultsServiceProtocol
    let collectionService: CollectionServiceProtocol
    let orderService: OrderServiceProtocol
    let cartService: CartServiceProtocol
    let profileService: ProfileServiceProtocol

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

        self.collectionService = collectionService
            ?? CollectionService(networkClient: networkClient)

        let sharedOrderService = OrderService(networkClient: networkClient)
        self.orderService = sharedOrderService
        self.cartService = CartService(
            networkClient: networkClient,
            orderService: sharedOrderService
        )

        self.profileService = ProfileService(
            networkClient: networkClient
        )
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
}
