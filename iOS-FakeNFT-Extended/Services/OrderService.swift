//
//  OrderService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Макалкин on 01.11.2026.
//

import Foundation

protocol OrderServiceProtocol: Sendable {
    func loadOrder() async throws -> Order
    func toggleCart(nftId: String) async throws -> Order
}

actor OrderService: OrderServiceProtocol {
    // MARK: - State

    private var cachedOrder: Order?
    private var operationTail: Task<Void, Never>?
    private var operationGeneration = 0

    // MARK: - Dependencies

    private let networkClient: NetworkClient

    // MARK: - Init

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Actions

    func loadOrder() async throws -> Order {
        try await performInQueue { service in
            try await service.fetchOrder()
        }
    }

    func toggleCart(nftId: String) async throws -> Order {
        try await performInQueue { service in
            let order = try await service.currentOrder()

            var updatedNfts = order.nfts

            if updatedNfts.contains(nftId) {
                updatedNfts.removeAll { $0 == nftId }
            } else {
                updatedNfts.append(nftId)
            }

            return try await service.updateOrder(updatedNfts)
        }
    }

    // MARK: - Order State

    private func currentOrder() async throws -> Order {
        if let cachedOrder {
            return cachedOrder
        }

        return try await fetchOrder()
    }

    // MARK: - Network

    private func fetchOrder() async throws -> Order {
        let request = OrderRequest()

        let order: Order = try await networkClient.send(
            request: request
        )

        cachedOrder = order

        return order
    }

    private func updateOrder(
        _ nfts: [String]
    ) async throws -> Order {
        let request = UpdateOrderRequest(
            nfts: nfts
        )

        let updatedOrder: Order = try await networkClient.send(
            request: request
        )

        cachedOrder = updatedOrder

        return updatedOrder
    }

    // MARK: - Queue

    private func performInQueue<T: Sendable>(
        _ operation: @escaping @Sendable (
            isolated OrderService
        ) async throws -> T
    ) async throws -> T {
        let previousOperation = operationTail

        operationGeneration += 1
        let operationId = operationGeneration

        let task = Task<T, Error> { [self] in
            if let previousOperation {
                await previousOperation.value
            }

            try Task.checkCancellation()

            return try await operation(self)
        }

        operationTail = Task<Void, Never> {
            _ = try? await task.value
        }

        defer {
            if operationId == operationGeneration {
                operationTail = nil
            }
        }

        return try await withTaskCancellationHandler {
            try await task.value
        } onCancel: {
            task.cancel()
        }
    }
}
