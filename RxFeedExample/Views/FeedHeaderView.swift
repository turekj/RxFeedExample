import Anchorage
import UIKit

class FeedHeaderView: UIView {

    let container: UIStackView = {
        let container = UIStackView(frame: .zero)
        container.axis = .horizontal
        container.distribution = .fill
        container.alignment = .center
        container.spacing = 15.0
        return container
    }()

    let avatar: UIImageView = {
        let avatar = UIImageView(image: #imageLiteral(resourceName: "avatar_placeholder"))
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 25
        avatar.clipsToBounds = true

        return avatar
    }()

    let author: FeedTwoLineView = FeedTwoLineView()
    let distance: FeedTwoLineView = FeedTwoLineView()

    init() {
        super.init(frame: .zero)

        distance.topLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        distance.bottomLabel.font = UIFont.systemFont(ofSize: 11, weight: .thin)
        addSubviews()
        setUpLayout()
    }

    // MARK: - Subviews

    private func addSubviews() {
        container.addArrangedSubview(avatar)
        container.addArrangedSubview(author)
        container.addArrangedSubview(distance)
        addSubview(container)
    }

    // MARK: - Layout

    private func setUpLayout() {
        container.edgeAnchors == edgeAnchors

        avatar.sizeAnchors == CGSize(width: 50, height: 50)
        author.widthAnchor == widthAnchor * 0.4
    }

    // MARK: - Required initializer

    required init?(coder _: NSCoder) { return nil }

}
