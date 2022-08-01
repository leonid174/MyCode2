//
//  WebViewerWebViewerIO.swift
//  RemotePhotoshoot
//
//  Created by Dmitry Ponomarev on 17/06/2020.
//  Copyright 2020 Unoporoduction. All rights reserved.
//

protocol WebViewerInterface {

}

protocol WebViewerDelegate: AnyObject {
    func willCloseWebViewer()
}
