import Anchorage
import RxSwift
import UIKit

class FeedCell: UICollectionViewCell {

    let container: UIStackView = {
        let container = UIStackView(frame: .zero)
        container.axis = .vertical
        container.distribution = .fill
        container.alignment = .fill
        container.spacing = 15.0
        return container
    }()

    let postLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        return label
    }()

    let postImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    let background: UIView = {
        let background = UIView(frame: .zero)
        background.backgroundColor = .white
        background.layer.cornerRadius = 4.0
        background.layer.masksToBounds = false
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOffset = CGSize(width: 0, height: 4)
        background.layer.shadowOpacity = 0.1
        background.layer.shadowRadius = 7.0

        return background
    }()

    let headerView: FeedHeaderView = FeedHeaderView()
    let footerView: FeedFooterView = FeedFooterView()

    var widthConstraint: NSLayoutConstraint?
    private(set) var disposeBag: DisposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setUpLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        postImage.image = #imageLiteral(resourceName: "placeholder")
        headerView.avatar.image = #imageLiteral(resourceName: "avatar_placeholder")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        background.layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: background.layer.cornerRadius
            ).cgPath
    }

    // MARK: - Subviews

    private func addSubviews() {
        container.addArrangedSubview(headerView)
        container.addArrangedSubview(postImage)
        container.addArrangedSubview(postLabel)
        container.addArrangedSubview(footerView)
        background.addSubview(container)
        contentView.addSubview(background)
    }

    // MARK: - Layout

    private func setUpLayout() {
        widthConstraint = (contentView.widthAnchor == 0)
        background.edgeAnchors == contentView.edgeAnchors
        container.edgeAnchors == contentView.edgeAnchors + 15

        postImage.heightAnchor == postImage.widthAnchor

        postLabel.setContentHuggingPriority(.required, for: .vertical)
        postLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    // MARK: - Required initializer

    required init?(coder _: NSCoder) { return nil }

}
