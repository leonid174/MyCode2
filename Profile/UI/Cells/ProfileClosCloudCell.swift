

import UIKit
import Kingfisher

final class ProfileClosCloudCell: ProfileCell {

    static let identifier = "ProfileClosCloudCell"

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var restrictedAccessPlaceholder: UIView!

    private var blurredEffectView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        let blurEffect = UIBlurEffect(style: .dark)
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.layer.cornerRadius = 4
        blurredEffectView.layer.masksToBounds = true

        photo.layer.cornerRadius = 4
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        blurredEffectView.frame = bounds
    }

    override func configureWith(model: ProfileCellModel) {
        super.configureWith(model: model)

        if !model.isAccessForMe {
            photo.addSubview(blurredEffectView)
        } else {
            blurredEffectView.removeFromSuperview()
        }

        activityIndicator.isHidden = !model.isUploadingNow

        guard let url = model.previewURL else { return }
        CacheImageHelper.showImage(url: url, into: photo, withCacheID: model.shootingID)
    }

    override func configureWith(model: ProfilePortfolioCellModel) {
        super.configureWith(model: model)

        blurredEffectView.removeFromSuperview()
        activityIndicator.isHidden = true

        guard let url = model.previewURL, let imageID = model.imageID else { return }
        CacheImageHelper.showImage(url: url, into: photo, withCacheID: imageID)
    }

    // MARK: - Public

    func showRestrictedAccessPlaceholder() {
        restrictedAccessPlaceholder.isHidden = false
        restrictedAccessPlaceholder.alpha = 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.3) {
                self.restrictedAccessPlaceholder.alpha = 0
            } completion: { _ in
                self.restrictedAccessPlaceholder.isHidden = true
            }
        }
    }
}
