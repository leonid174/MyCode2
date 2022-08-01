

import UIKit
import Kingfisher

internal class ProfileCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var expires: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!

    func configureWith(model: ProfileCellModel) {
        titleLabel.text = model.title
        countLabel.text = model.count
        expires.text = model.dateExpire
        selectedImage.isHidden = !model.isSelected
    }

    func configureWith(model: ProfilePortfolioCellModel) {
        titleLabel.text = nil
        countLabel.text = nil
        expires.text = nil
        selectedImage.isHidden = true
    }
}
