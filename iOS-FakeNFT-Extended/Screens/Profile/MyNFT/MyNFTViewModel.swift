//
//  MyNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-11-02.
//
import Observation
import SwiftUI
import ProgressHUD

@MainActor
@Observable
final class MyNFTViewModel {
    private let assembly: ServicesAssembly
    private var profileModel: Profile?
    
    private var nfts: [MyNFTModel] = []
    
    var currentFilter: MyNFTFilters {
        didSet {
            userDefaultsService.saveMyNFTFilter(currentFilter)
        }
    }
    
    private let userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService()
    
    init(assembly: ServicesAssembly, profileModel: Profile) {
        self.assembly = assembly
        self.profileModel = profileModel
        self.currentFilter = userDefaultsService.fetchMyNFTFilter() ?? .rating
    }
    
    var filtredNFTs: [MyNFTModel] {
        switch currentFilter {
        case .price: nfts.sorted { $0.price > $1.price }
        case .rating: nfts.sorted { $0.rating > $1.rating }
        case .name: nfts.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    func loadNfts(ids: [String]) async {
        guard !ids.isEmpty else {
            nfts = []
            return
        }

        ProgressHUD.animate()

        do {
            nfts = try await withThrowingTaskGroup(
                of: (Int, MyNFTModel).self
            ) { group in

                for (index, id) in ids.enumerated() {
                    group.addTask {
                        let nft = try await self.assembly.nftService.loadNft(id: id)
                        let isLiked = await MainActor.run {
                            self.profileModel?.likes.contains(nft.id) ?? false
                        }

                        let model = MyNFTModel(nft: nft, isLiked: isLiked)

                        return (index, model)
                    }
                }

                var result = [(Int, MyNFTModel)]()

                for try await item in group {
                    result.append(item)
                }

                return result
                    .sorted { $0.0 < $1.0 }
                    .map(\.1)
            }

            ProgressHUD.dismiss()

        } catch {            
            print(error.localizedDescription)
            ProgressHUD.dismiss()
        }
    }
    
    func toggleLike(nftId: String) async {
        guard let currentProfile = profileModel else { return }

        var updatedLikes = currentProfile.likes

        if updatedLikes.contains(nftId) {
            updatedLikes.removeAll { $0 == nftId }
        } else {
            updatedLikes.append(nftId)
        }

        do {
            let updatedProfile = try await assembly.profileService.updateProfile(
                name: nil,
                avatar: nil,
                description: nil,
                website: nil,
                likes: updatedLikes
            )

            profileModel = updatedProfile

            if let index = nfts.firstIndex(where: { $0.id == nftId }) {
                nfts[index].isLiked = updatedProfile.likes.contains(nftId)
            }
        } catch {
            print(error)
        }
    }
}
