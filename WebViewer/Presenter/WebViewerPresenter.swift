

final class WebViewerPresenter {
    var interactor: WebViewerInteractorInterface?
    weak var root: WebViewerDelegate?
    weak var controller: WebViewerControllerInterface?
}

extension WebViewerPresenter: WebViewerInterface {

}

extension WebViewerPresenter: WebViewerControllerDelegate {
    func didReadyToWork() {

    }

    func didPressCloseButton() {
        root?.willCloseWebViewer()
    }
}

extension WebViewerPresenter: WebViewerInteractorDelegate {

}
