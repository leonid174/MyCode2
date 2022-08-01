//
//  WebViewerWebViewerControllerIO.swift
//  RemotePhotoshoot
//
//  Created by Dmitry Ponomarev on 17/06/2020.
//  Copyright 2020 Unoporoduction. All rights reserved.
//

protocol WebViewerControllerInterface: AnyObject {

}

protocol WebViewerControllerDelegate: AnyObject {
    func didReadyToWork()
    func didPressCloseButton()
}
