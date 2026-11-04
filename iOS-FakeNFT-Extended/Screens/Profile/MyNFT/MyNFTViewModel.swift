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
    private let nftService: NftService
    
    private var nfts: [MyNFTModel] = []
    
    var currentFilter: MyNFTFilters = MyNFTFilters.rating
    
    init(nftService: NftService) {
        self.nftService = nftService
    }
    
    var filtredNFTs: [MyNFTModel] {
        switch currentFilter {
        case .price:
            return nfts.sorted {
                $0.price > $1.price
            }
        case .rating:
            return nfts.sorted {
                $0.rating > $1.rating
            }
        case .name:
            return nfts.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
    
    func load() {
        
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
                        let nft = try await self.nftService.loadNft(id: id)
                        let model = MyNFTModel(nft: nft)

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
}
