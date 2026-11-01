import Foundation

struct Nft: Codable, Identifiable, Sendable {
    let createdAt: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let website: String
    let id: String
}
