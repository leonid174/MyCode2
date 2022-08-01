

import UIKit

final class WebViewerHeader: NSObject {

    weak var controller: WebViewerViewController!

    init(root: WebViewerDelegate, url: URL) {
        super.init()

        let presenter = WebViewerPresenter()
        let interactor = WebViewerInteractor()
        controller = moduleController()

        presenter.root = root
        presenter.controller = controller
        presenter.interactor = interactor

        controller.presenter = presenter
        controller.webURL = url
        interactor.presenter = presenter
    }

    func currentController() -> UIViewController {
        return controller
    }

    // MARK: - private

    private func moduleController() -> WebViewerViewController {
        guard let controller = moduleStoryboard().instantiateViewController(withIdentifier: "WebViewerViewController") as? WebViewerViewController else { fatalError() }
        return controller
    }

    private func moduleStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "WebViewer", bundle: nil)
    }
}

extension WebViewerHeader: WebViewerInterface {

}
