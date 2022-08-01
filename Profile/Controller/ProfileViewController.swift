

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var registerDateLabel: UILabel!
    @IBOutlet weak var roleLabelHeight: NSLayoutConstraint!

    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!

    @IBOutlet weak var socialsHeight: NSLayoutConstraint!
    @IBOutlet weak var socialsTopMargin: NSLayoutConstraint!

    @IBOutlet weak var allShootingsCollectionView: UICollectionView!
    @IBOutlet weak var allShootingsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    var presenter: ProfileControllerDelegate?

    private var data: [ProfilePortfolioCellModel] = []

    // MARK: - Load view

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = 40

        websiteButton.layer.cornerRadius = 12
        instagramButton.layer.cornerRadius = 12

        statusView.layer.cornerRadius = 20
        closeButton.setTitle(nil, for: .normal)

        presenter?.didReadyToWork()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let allShootingsHeight = allShootingsCollectionView.collectionViewLayout.collectionViewContentSize.height
        allShootingsCollectionViewHeight.constant = allShootingsHeight

        let width = view.frame.width

        let height = roleLabel.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        roleLabelHeight.constant = height
        view.layoutIfNeeded()
    }

    // MARK: - Actions

    @IBAction func settingsButtonAction(_ sender: Any) {
        presenter?.didPressSettingsButton()
    }

    @IBAction func websiteButtonAction(_ sender: Any) {
        presenter?.didPressWebsiteButton()
    }

    @IBAction func instagramButtonAction(_ sender: Any) {
        presenter?.didPressInstagramButton()
    }

    @IBAction func profileButtonAction(_ sender: Any) {
        presenter?.didPressProfileButton()
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        presenter?.didPressCloseButton()
    }
}

extension ProfileViewController: ProfileControllerInterface {
    func updateViewFrom(data: ProfileModel) {
        nameLabel.text = data.name

        if data.userName == nil || data.userName == "" {
            usernameLabel.text = nil
        } else {
            usernameLabel.text = "@\(data.userName!)"
        }

        roleLabel.text = data.info
        let roles = data.roles?.map({ role -> String in
            // костыль из-за того, что на сервере photograph вместо photographer
            if role == "photograph" {
                return "photographer"
            }
            return role
        })
        registerDateLabel.text = roles?.joined(separator: ", ").capitalized

        if let profileImage = data.photo {
            let imageResource = ImageResource(downloadURL: profileImage)
            profileImageView.kf.setImage(with: imageResource, options: [.cacheOriginalImage])
        } else {
            profileImageView.image = nil
        }

        nameLabel.isHidden = false
        usernameLabel.isHidden = false
        roleLabel.isHidden = false
        registerDateLabel.isHidden = false
        profileImageView.isHidden = false

        websiteButton.isHidden = data.websiteLink == nil
        instagramButton.isHidden = data.instagramLink == nil

        socialsHeight.constant = websiteButton.isHidden && instagramButton.isHidden ? 0 : 54
        socialsTopMargin.constant = websiteButton.isHidden && instagramButton.isHidden ? 0 : 20

        statusView.isHidden = false
        switch data.status {
        case .none:
            statusLabel.text = "Add profile info"
            statusImageView.image = #imageLiteral(resourceName: "profileStatusChecking")
            statusView.backgroundColor = Color.grayProfileStatusApproved.color
        case .some(let status):
            switch status {
            case .filled, .redacted:
                statusLabel.text = "Pending verification"
                statusImageView.image = #imageLiteral(resourceName: "profileStatusChecking")
                statusView.backgroundColor = Color.grayProfileStatusApproved.color
            case .approved:
                statusLabel.text = "Verified"
                statusImageView.image = #imageLiteral(resourceName: "profileStatusApproved")
                statusView.backgroundColor = Color.grayProfileStatusApproved.color
            case .rejected:
                statusLabel.text = "Changes required"
                statusImageView.image = #imageLiteral(resourceName: "profileStatusDeclined")
                statusView.backgroundColor = Color.orangeProfileStatusRejected.color
            }
        }

        view.layoutIfNeeded()
    }

    func updateCellsFrom(data: [ProfilePortfolioCellModel]) {
        self.data = data
        allShootingsCollectionView.reloadData()
    }

    func showActionsAlert() {
        let actionsController = ActionController()
        let editProfileAction = Action(title: "Edit profile", image: #imageLiteral(resourceName: "profileEditProfile")) { [weak self] in
            self?.presenter?.didPressEditButton()
        }
        let blockedUsersAction = Action(title: "Blocked users", image: #imageLiteral(resourceName: "profileBlockedUsers")) { [weak self] in
            self?.presenter?.didPressBlockedUsersButton()
        }
        let signOutAction = Action(title: "Sign out", image: #imageLiteral(resourceName: "profileSignOut")) { [weak self] in
            self?.presenter?.didPressLogoutButton()
        }
        actionsController.addAction(editProfileAction)
        actionsController.addAction(blockedUsersAction)
        actionsController.addAction(signOutAction)

        present(actionsController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter?.didSelectCell(at: indexPath)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = data[indexPath.row]

        let identifier = ProfileClosCloudCell.identifier

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ProfileCell
        cell.configureWith(model: model)

        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 48) / 2 - 1
        return CGSize(width: width, height: width)
    }
}
