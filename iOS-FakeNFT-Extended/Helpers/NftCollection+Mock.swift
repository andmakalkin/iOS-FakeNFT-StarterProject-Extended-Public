//
//  NftCollection+Mock.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 22.10.2026.
//

extension NftCollection {
    static let mockCollections: [NftCollection] = [
        peach,
        blue,
        brown,
        beige,
        gray,
        green,
        pink,
        white,
        yellow
    ]

    static let peach = NftCollection(
        id: "1",
        name: "Peach",
        nfts: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
        createdAt: nil,
        cover: "collectionCover6",
        description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
        author: "John Doe",
        website: "https://yandex.ru/legal/practicum_termsofuse"
    )

    static let blue = NftCollection(
        id: "2",
        name: "Blue",
        nfts: [
            "12", "13", "14", "15", "16", "17"
        ],
        createdAt: nil,
        cover: "collectionCover2",
        description: nil,
        author: nil,
        website: nil
    )

    static let brown = NftCollection(
        id: "3",
        name: "Brown",
        nfts: [
            "18", "19", "20", "21",
            "22", "23", "24", "25"
        ],
        createdAt: nil,
        cover: "collectionCover3",
        description: nil,
        author: nil,
        website: nil
    )

    static let beige = NftCollection(
        id: "4",
        name: "Beige",
        nfts: [],
        createdAt: nil,
        cover: "collectionCover1",
        description: nil,
        author: nil,
        website: nil
    )

    static let gray = NftCollection(
        id: "5",
        name: "Gray",
        nfts: [],
        createdAt: nil,
        cover: "collectionCover4",
        description: nil,
        author: nil,
        website: nil
    )

    static let green = NftCollection(
        id: "6",
        name: "Green",
        nfts: [],
        createdAt: nil,
        cover: "collectionCover5",
        description: nil,
        author: nil,
        website: nil
    )

    static let pink = NftCollection(
        id: "7",
        name: "Pink",
        nfts: [],
        createdAt: nil,
        cover: "collectionCover7",
        description: nil,
        author: nil,
        website: nil
    )

    static let white = NftCollection(
        id: "8",
        name: "White",
        nfts: [],
        createdAt: nil,
        cover: "collectionCover8",
        description: nil,
        author: nil,
        website: nil
    )

    static let yellow = NftCollection(
        id: "9",
        name: "Yellow",
        nfts: [],
        createdAt: nil,
        cover: "collectionCover9",
        description: nil,
        author: nil,
        website: nil
    )
}
