import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: Nft) async
    func getNft(with id: String) async -> Nft?
}

actor NftStorageImpl: NftStorage {
    private var storage: [String: Nft] = [:]

    func saveNft(_ nft: Nft) async {
        storage[nft.id] = nft
    }

    func getNft(with id: String) async -> Nft? {
        storage[id]
    }
}
