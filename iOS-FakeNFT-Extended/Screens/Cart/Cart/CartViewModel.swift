//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Albina Musugalieva.
//
import Foundation
import Observation

enum CartNftSortOption: String, CaseIterable {
    case price = "По цене"
    case rating = "По рейтингу"
    case name = "По названию"
    
    var title: String { self.rawValue }
}

enum CartViewState {
    case loading
    case empty
    case content
    case error(String)
}

@Observable
@MainActor
final class CartViewModel {
    var state: CartViewState = .loading
    var cartNfts: [Nft] = []
    var showErrorAlert = false
    var errorMessage = ""
    
    private var _currentSortOption: CartNftSortOption = .name
    
    var currentSortOption: CartNftSortOption {
        get {
            _currentSortOption
        }
        set {
            _currentSortOption = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: Self.sortKey)
            applySort()
        }
    }
    
    let cartService: CartServiceProtocol
    private static let sortKey = "cart.sortOptionKey"
    
    var totalPrice: Double { cartNfts.reduce(0) { $0 + $1.price } }
    var totalCount: Int { cartNfts.count }
    
    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
        if let savedRaw = UserDefaults.standard.string(forKey: Self.sortKey),
           let savedOption = CartNftSortOption(rawValue: savedRaw) {
            self._currentSortOption = savedOption
        } else {
            self._currentSortOption = .name
        }
    }
    
    func loadCartData() {
        state = .loading
        
        let _ = Task {
            do {
                let cartOrder = try await cartService.fetchCart()
                let nftIds = cartOrder.nfts
                
                if nftIds.isEmpty {
                    state = .empty
                    return
                }
                
                self.cartNfts = try await loadNfts(ids: nftIds)
                applySort()
                state = .content
            } catch {
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
                state = .error(error.localizedDescription)
            }
        }
    }
    
    private func loadNfts(ids: [String]) async throws -> [Nft] {
        try await withThrowingTaskGroup(of: (Int, Nft).self) { group in
            for (index, id) in ids.enumerated() {
                group.addTask {
                    let nft = try await self.cartService.fetchNftById(id: id)
                    return (index, nft)
                }
            }
            
            var results = [Nft?](repeating: nil, count: ids.count)
            for try await (index, nft) in group {
                results[index] = nft
            }
            return results.compactMap { $0 }
        }
    }
    
    func deleteNft(id: String) {
        state = .loading
        
        let _ = Task {
            do {
                try await Task.sleep(nanoseconds: 300_000_000)
                self.cartNfts = self.cartNfts.filter { $0.id != id }
                state = cartNfts.isEmpty ? .empty : .content
            } catch {
                state = .content
            }
        }
    }
    
    func applySort() {
        switch currentSortOption {
        case .price: cartNfts.sort { $0.price < $1.price }
        case .rating: cartNfts.sort { $0.rating > $1.rating }
        case .name: cartNfts.sort { $0.name.localizedCompare($1.name) == .orderedAscending }
        }
    }
}

extension CartViewState {
    var isLoading: Bool { if case .loading = self { return true }; return false }
    var isEmpty: Bool { if case .empty = self { return true }; return false }
}
