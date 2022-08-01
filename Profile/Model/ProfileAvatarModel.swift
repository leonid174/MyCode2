

import Foundation

struct ProfileAvatarModel {
    let avatarID: String
    let originalURL: String?
    let previewURL: String?

    init(apiProfileAvatar: APIProfileAvatar) {
        self.avatarID = apiProfileAvatar.avatarID
        self.originalURL = apiProfileAvatar.originalURL
        self.previewURL = apiProfileAvatar.previewURL
    }

    init(avatarID: String, originalURL: String?, previewURL: String?) {
        self.avatarID = avatarID
        self.originalURL = originalURL
        self.previewURL = previewURL
    }
}
