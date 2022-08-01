//
//  WebViewerWebViewerPresenter.swift
//  RemotePhotoshoot
//
//  Created by Dmitry Ponomarev on 17/06/2020.
//  Copyright 2020 Unoporoduction. All rights reserved.
//

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
