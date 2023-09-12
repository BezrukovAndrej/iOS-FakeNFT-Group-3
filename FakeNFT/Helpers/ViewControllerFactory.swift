import UIKit

final class ViewControllerFactory {
    func makeWebView(url: URL) -> WebViewViewController {
        let controller = WebViewViewController(url: url)
        // TODO: - индикатор загрузки
        return controller
    }
    
    func makeUserNFTViewController(nftList: [String]) -> UserNFTViewController {
        let userNFTViewController = UserNFTViewController(nftList: nftList,
                                                          viewModel: UserNFTViewModel(model: NFTService()))
        return userNFTViewController
    }
    
    func makeFavoritesNFTViewController() -> FavoritesNFTViewController {
        return FavoritesNFTViewController()
    }
    
    func makeEditingViewController() -> EditingViewController {
        return EditingViewController(viewModel: EditingViewModel(profileService: ProfileService(networkClient: DefaultNetworkClient())))
    }
}
