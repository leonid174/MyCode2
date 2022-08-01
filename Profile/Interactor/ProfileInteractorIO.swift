

import Foundation

protocol ProfileInteractorInterface {
    func loadProfileData()

    func loadPhotoData(limit: Int, skip: Int, completion: @escaping (Result<[ProfileCellModel], Error>) -> Void)
    func isShootingAccessForMe(model: ProfileCellModel) -> Bool
}

protocol ProfileInteractorDelegate: AnyObject {
    func didLoad(profileData: ProfileModel)
    func didFailLoadProfileDataWith(error: Error)
}
