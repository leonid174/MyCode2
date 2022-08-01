

import UIKit

final class ProfilePresenter: NSObject {
    var interactor: ProfileInteractorInterface?
    weak var root: ProfileDelegate?
    weak var controller: ProfileControllerInterface?

    private var profileData: ProfileModel?
    private var cellData: [ProfilePortfolioCellModel] = []

    private var devToolsCounter = 0
}

extension ProfilePresenter: ProfileInterface {
    func reloadData() {
        interactor?.loadProfileData()
    }
}

extension ProfilePresenter: ProfileControllerDelegate {
    func didReadyToWork() {
        reloadData()
    }

    func didPressProfileButton() {
        if devToolsCounter < 20 {
            devToolsCounter += 1
        } else {
            root?.willShowDevTools()
        }
    }

    func didPressEditButton() {
        guard let profile = profileData else {
            closLog.critical("Profile data is nil")
            return
        }
        root?.willShowEditProfileFromProfile(profile: profile) { [weak self] in
            // здесь небольшая задержка, чтобы данные на бэке успели обновиться между двумя запроса подряд на обновление и на получение данных
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.interactor?.loadProfileData()
            }
        }
    }

    func didPressWebsiteButton() {
        guard let profileData = profileData else { return }
        guard let websiteLink = profileData.websiteLink else { return }
        guard let url = URL(string: websiteLink) else { return }

        if var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            if comps.scheme == nil {
                comps.scheme = "http"
            }
            if let validUrl = comps.url {
                root?.willOpenWebsiteFromProfileWith(url: validUrl)
            }
        } else {
            root?.willOpenWebsiteFromProfileWith(url: url)
        }
    }

    func didPressInstagramButton() {
        guard let profileData = profileData else { return }
        guard let instagramLink = profileData.instagramLink else { return }

        if instagramLink.contains("instagram.com"), let webURL = URL(string: instagramLink) {
            if UIApplication.shared.canOpenURL(webURL) {
                UIApplication.shared.open(webURL)
                return
            }
        }

        guard let appURL = URL(string: "instagram://user?username=\(instagramLink)") else { return }

        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            guard let webURL = URL(string: "https://instagram.com/\(instagramLink)") else { return }
            UIApplication.shared.open(webURL)
        }
    }

    func didPressSettingsButton() {
        controller?.showActionsAlert()
    }

    func didPressLogoutButton() {
        root?.shouldLogOutFromProfile()
    }

    func didSelectCell(at index: IndexPath) {}

    func didPressBlockedUsersButton() {
        root?.willShowBlockedUsers()
    }

    func didPressCloseButton() {
        root?.willCloseProfile()
    }
}

extension ProfilePresenter: ProfileInteractorDelegate {
    func didLoad(profileData: ProfileModel) {
        self.profileData = profileData

        cellData = profileData.artWorks.map { artWork in return ProfilePortfolioCellModel(imageID: artWork.avatarID, preview: artWork.previewURL) }

        controller?.updateCellsFrom(data: cellData)
        controller?.updateViewFrom(data: profileData)
    }

    func didFailLoadProfileDataWith(error: Error) {

    }
}
