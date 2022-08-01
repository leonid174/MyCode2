

import UIKit

final class ProfileCameraRollCell: ProfileCell {

    static let identifier = "ProfileCameraRollCell"

    @IBOutlet weak var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        photo.layer.cornerRadius = 4
    }

}
