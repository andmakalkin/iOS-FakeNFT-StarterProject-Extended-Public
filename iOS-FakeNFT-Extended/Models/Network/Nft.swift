import Foundation

struct Nft: Codable, Identifiable, Sendable {
    let id: String
    let images: [URL]
    let name: String
    let rating: Int
    let price: Double

    let createdAt: String?
    let description: String?
    let author: String?
    let website: String?
}
