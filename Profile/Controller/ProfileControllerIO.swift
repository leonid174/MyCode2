

import Foundation

protocol ProfileControllerInterface: AnyObject {
    func updateViewFrom(data: ProfileModel)
    func updateCellsFrom(data: [ProfilePortfolioCellModel])
    func showActionsAlert()
}

protocol ProfileControllerDelegate: AnyObject {
    func didReadyToWork()

    func didPressProfileButton()
    func didPressEditButton()
    func didPressWebsiteButton()
    func didPressInstagramButton()
    func didPressSettingsButton()
    func didPressBlockedUsersButton()
    func didPressCloseButton()

    func didPressLogoutButton()

    func didSelectCell(at index: IndexPath)

//    func updateView()
}
