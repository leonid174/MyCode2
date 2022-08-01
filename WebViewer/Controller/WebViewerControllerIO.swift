

protocol WebViewerControllerInterface: AnyObject {

}

protocol WebViewerControllerDelegate: AnyObject {
    func didReadyToWork()
    func didPressCloseButton()
}
