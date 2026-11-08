import SwiftUI

struct NftDetailBridgeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    @Environment(ServicesAssembly.self) var servicesAssembly

    let nftId: String

    func makeUIViewController(context: Context) -> UIViewController {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftInput = NftDetailInput(id: nftId)
        return assembly.build(with: nftInput)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Обновляет состояние указанного контроллера представления новой информацией из SwiftUI.
    }
}

private enum Constants {
    static let testNftId = "7773e33c-ec15-4230-a102-92426a3a6d5a"
}
