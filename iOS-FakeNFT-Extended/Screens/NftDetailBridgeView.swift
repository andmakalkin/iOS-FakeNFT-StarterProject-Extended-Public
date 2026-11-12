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

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
