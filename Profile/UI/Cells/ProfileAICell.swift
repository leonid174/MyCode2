

import UIKit
import Kingfisher

final class ProfileAICell: ProfileCell {

    static let identifier = "ProfileAICell"

    @IBOutlet weak var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        photo.layer.cornerRadius = 4
    }

    override func configureWith(model: ProfileCellModel) {
        super.configureWith(model: model)

        guard let url = model.previewURL else { return }
        CacheImageHelper.showImage(url: url, into: photo, withCacheID: model.shootingID)
    }
}
