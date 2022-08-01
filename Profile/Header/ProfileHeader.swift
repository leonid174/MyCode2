

import UIKit

final class ProfileHeader: NSObject {

    weak var controller: ProfileViewController!
    weak var presenter: ProfileInterface!

    init(root: ProfileDelegate, apiManager: APIUserManagerInterface, apiImagesManager: APIImagesMangerInterface, localCacheManager: LocalCacheManagerInterface, localKeyValueStore: KeyStoreManagerInterface) {
        super.init()

        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(apiManager: apiManager, apiImagesManager: apiImagesManager, localCacheManager: localCacheManager, localKeyValueStore: localKeyValueStore)
        controller = moduleController()

        presenter.root = root
        presenter.controller = controller
        presenter.interactor = interactor

        controller.presenter = presenter
        interactor.presenter = presenter

        self.presenter = presenter
    }

    func currentController() -> UIViewController {
        return controller
    }

    // MARK: - private

    private func moduleController() -> ProfileViewController {
        return moduleStoryboard().instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }

    private func moduleStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: nil)
    }
}

extension ProfileHeader: ProfileInterface {
    func reloadData() {
        presenter.reloadData()
    }
}
