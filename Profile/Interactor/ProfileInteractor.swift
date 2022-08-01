

import Foundation

final class ProfileInteractor: NSObject {
    weak var presenter: ProfileInteractorDelegate?

    private let apiManager: APIUserManagerInterface
    private let apiImagesManager: APIImagesMangerInterface
    private let localCacheManager: LocalCacheManagerInterface
    private let localKeyValueStore: KeyStoreManagerInterface

    init(apiManager: APIUserManagerInterface, apiImagesManager: APIImagesMangerInterface, localCacheManager: LocalCacheManagerInterface, localKeyValueStore: KeyStoreManagerInterface) {
        self.apiManager = apiManager
        self.apiImagesManager = apiImagesManager
        self.localCacheManager = localCacheManager
        self.localKeyValueStore = localKeyValueStore
    }
}

extension ProfileInteractor: ProfileInteractorInterface {
    func loadProfileData() {
        apiManager.userProfile { result in
            switch result {
            case .success(let apiResponse):
                let profileModel = ProfileModel(apiProfile: apiResponse)
                self.presenter?.didLoad(profileData: profileModel)
            case .failure(let error):
                self.presenter?.didFailLoadProfileDataWith(error: error)
            }
        }
    }

    func loadPhotoData(limit: Int, skip: Int, completion: @escaping (Result<[ProfileCellModel], Error>) -> Void) {
        apiImagesManager.myRoomWith(limit: limit, skip: skip) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let apiShootings):
                var data = apiShootings.data.map { ProfileCellModel(from: $0) }

                // Добавляем локальные альбомы (либо AI, либо те, которые сохранены на стороне модели)
                var localShootingModels: [ProfileCellModel] = []
                for localShooting in self.localCacheManager.allShootings() {
                    if let roomID = localShooting.roomID {
                        if roomID == "AI" {
                            if let lastFile = self.localCacheManager.lastAIFile(inRoom: roomID) {
                                guard let model = ProfileCellModel(fromLocalSession: localShooting, andLastFileInSession: lastFile) else { continue }

                                localShootingModels.append(model)
                            }
                        } else {
                            if let lastFile = self.localCacheManager.lastNotAIFile(inRoom: roomID) {
                                guard let model = AllShootingsModel(fromLocalSession: localShooting, andLastFileInSession: lastFile) else { continue }

                                // Для локальных данных берем превью из кэша
                                if model.saveTarget == .cache {
                                    if let row = data.firstIndex(where: {$0.shootingID == model.shootingID}), let lastFilePreviewPath = lastFile.previewPath {
                                        data[row].previewURL = URL(fileURLWithPath: documensDirectory()).appendingPathComponent(lastFilePreviewPath)
                                    }
                                }
                            }
                        }
                    }
                }

                data.insert(contentsOf: localShootingModels, at: 0)
                data.sort { return $0.shootingDate > $1.shootingDate }

                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func isShootingAccessForMe(model: ProfileCellModel) -> Bool {
        switch model.saveTarget {
        case .closCloud, .ai:
            return model.isAccessForMe
        case .cache, .cameraRoll, .dropbox:
            let currentUserID = localKeyValueStore.restoreString(forKey: .kUserID) ?? ""
            return model.modelIDs?.contains(currentUserID) ?? false
        }
    }
}
