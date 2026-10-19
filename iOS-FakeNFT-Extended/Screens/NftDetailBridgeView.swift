import SwiftUI

struct NftDetailBridgeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = NftDetailViewController

    @Environment(ServicesAssembly.self) var servicesAssembly

    func makeUIViewController(context: Context) -> NftDetailViewController {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftInput = NftDetailInput(id: Constants.testNftId)
        let nftViewController = assembly.build(with: nftInput) as! NftDetailViewController
        return nftViewController
    }

    func updateUIViewController(_ uiViewController: NftDetailViewController, context: Context) {
        // Обновляет состояние указанного контроллера представления новой информацией из SwiftUI.
    }
}

private enum Constants {
    static let testNftId = "7773e33c-ec15-4230-a102-92426a3a6d5a"
}
