

import UIKit
import WebKit

final class WebViewerViewController: UIViewController {

    var presenter: WebViewerControllerDelegate?
    var webURL: URL?

    // MARK: - Outlets

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var bottomPanelView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Load view

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        loadURL()
        presenter?.didReadyToWork()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButton.isEnabled = webView.canGoBack
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomPanelView.roundCorners(corners: [.topLeft, .topRight], radius: 16)
    }

    // MARK: - Actions

    @IBAction func backButtonAction(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        presenter?.didPressCloseButton()
    }

    // MARK: - Private

    private func loadURL() {
        guard let webURL = webURL else { return closLog.error("Fail load URL") }

        let request = URLRequest(url: webURL)
        webView.load(request)
    }
}

extension WebViewerViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        activityIndicator.isHidden = true
    }
}

extension WebViewerViewController: WebViewerControllerInterface {

}
