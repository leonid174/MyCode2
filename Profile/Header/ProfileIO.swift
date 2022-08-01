

import Foundation

protocol ProfileInterface: AnyObject {
    func reloadData()
}

protocol ProfileDelegate: AnyObject {
    func willShowEditProfileFromProfile(profile: ProfileModel, completion: @escaping () -> Void)
    func shouldLogOutFromProfile()
    func willShowShootingFromProfile(with shootingModel: GlobalShootingModel, isMeAccess: Bool, completion: @escaping (Bool) -> Void)
    func willOpenWebsiteFromProfileWith(url: URL)

    func willShowDevTools()

    func willShowBlockedUsers()

    func willCloseProfile()
}
