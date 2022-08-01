

import Foundation

struct ProfileModel {
    let userID: String
    let name: String?
    let userName: String?
    let info: String?
    let registerDate: String

    let photo: URL?

    let websiteLink: String?
    let instagramLink: String?

    let email: String?
    let snapchat: String?
    let tiktok: String?
    let youtube: String?
    let facebook: String?
    let roles: [String]?
    let artWorks: [ProfileAvatarModel]
    let status: ProfileStatus?

    init(apiProfile: APIProfile) {
        self.userID = apiProfile.userID
        self.name = apiProfile.name
        self.userName = apiProfile.userName
        self.info = apiProfile.profileInfo
        self.registerDate = "" // apiProfile.registerDate.date.toString()
        self.roles = apiProfile.roles
        self.status = apiProfile.status

        self.artWorks = apiProfile.artWorks?.map { apiAvatar in
            return ProfileAvatarModel(apiProfileAvatar: apiAvatar)
        } ?? []

        if let profileImageURLString = apiProfile.profileImageURL, !profileImageURLString.isEmpty, let profileImageURL = URL(string: profileImageURLString) {
            self.photo = profileImageURL
        } else {
            self.photo = nil
        }

        if let website = apiProfile.website, !website.isEmpty {
            self.websiteLink = website
        } else {
            self.websiteLink = nil
        }

        if let instagram = apiProfile.instagram, !instagram.isEmpty {
            self.instagramLink = instagram
        } else {
            self.instagramLink = nil
        }

        if let email = apiProfile.email, !email.isEmpty {
            self.email = email
        } else {
            self.email = nil
        }

        if let snapchat = apiProfile.snapchat, !snapchat.isEmpty {
            self.snapchat = snapchat
        } else {
            self.snapchat = nil
        }

        if let tiktok = apiProfile.tiktok, !tiktok.isEmpty {
            self.tiktok = tiktok
        } else {
            self.tiktok = nil
        }

        if let youtube = apiProfile.youtube, !youtube.isEmpty {
            self.youtube = youtube
        } else {
            self.youtube = nil
        }

        if let facebook = apiProfile.facebook, !facebook.isEmpty {
            self.facebook = facebook
        } else {
            self.facebook = nil
        }
    }
}

struct ProfileCellModel {
    let shootingID: String
    let title: String
    let dateExpire: String
    var count: String
    var previewURL: URL?
    let shareLink: String

    var saveTarget: GlobalSaveTarget
    let isAccessForMe: Bool
    var isUploadingNow: Bool

    var shootingDate: Date

    var isSelected = false

    let photographID: String
    let modelIDs: [String]?

    init(from apiShooting: APIShooting) {
        let authorName = apiShooting.owner.count != 0 ? apiShooting.owner : "Unnown"

        shootingID = apiShooting.galleryID
        title = authorName + " - " + (apiShooting.date?.date.toString() ?? "")
        previewURL = URL(string: apiShooting.logo)
        shareLink = apiShooting.shareLink

        isAccessForMe = apiShooting.isMeOwner

        if apiShooting.uploadImageCount != nil {
            isUploadingNow = (apiShooting.imageCount + apiShooting.retouchImageCount) != apiShooting.uploadImageCount
        } else {
            isUploadingNow = false
        }

        if let dateExpire = apiShooting.dateExpire {
            self.dateExpire = "gallery_cell_expiresIn".locale() + String(dateExpire.date.daysUntil) + "gallery_cell_days".locale()
        } else {
            self.dateExpire = "???"
        }

        if let date = apiShooting.date {
            shootingDate = date.date
        } else {
            shootingDate = Date()
            closLog.critical("Empty date! id: \(apiShooting.galleryID)")
        }

        let photoTextForLabel = "gallery_cell_photos".locale()
        if let localImagesCount = apiShooting.localImagesCount, localImagesCount > 0 {
            saveTarget = .cameraRoll
            count = "\(localImagesCount) \(photoTextForLabel)"
        } else if let dropboxImagesCount = apiShooting.dropboxImagesCount, dropboxImagesCount > 0 {
            saveTarget = .dropbox
            count = "\(dropboxImagesCount) \(photoTextForLabel)"
        } else if let innerGalleryImagesCount = apiShooting.innerGalleryImagesCount, innerGalleryImagesCount > 0 {
            saveTarget = .cache
            count = "\(innerGalleryImagesCount) \(photoTextForLabel)"
        } else {
            saveTarget = .closCloud
            count = "\(apiShooting.imageCount) \(photoTextForLabel)"
        }

        photographID = apiShooting.photographID
        modelIDs = apiShooting.modelIDs
    }

    init?(fromLocalSession localSession: LocalSessionEntity, andLastFileInSession lastFile: LocalFileEntity) {
        // Используем не дату шутинга, а дату последнего файла, чтобы покрыть кейс AI
        guard let date = lastFile.date, let roomID = localSession.roomID else {
            closLog.critical("Cache file without date or roomID")
            return nil
        }

        shootingID = roomID

        if let path = lastFile.previewPath {
            previewURL = URL(fileURLWithPath: documensDirectory()).appendingPathComponent(path)
        } else {
            closLog.error("[❌ Error] Cache file without preview path")
            previewURL = nil
        }

        if roomID == "AI" {
            title = "AI CAMERA"
            saveTarget = .ai
        } else {
            title = date.toString()
            saveTarget = .cache
        }

        count = ""
//        count = "\(localSession.files?.count ?? 0) " + "gallery_cell_photos".locale()
        dateExpire = ""
        shareLink = ""

        isAccessForMe = true
        isUploadingNow = false

        shootingDate = date

        photographID = ""
        modelIDs = nil
    }
}

struct ProfilePortfolioCellModel {
    let imageID: String?
    let previewURL: URL?

    init(imageID: String, preview: String?) {
        self.imageID = imageID
        guard let previewURLString = preview else {
            previewURL = nil
            return
        }
        previewURL = URL(string: previewURLString)
    }
}
