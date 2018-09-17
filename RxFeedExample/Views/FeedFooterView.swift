import Anchorage
import UIKit

class FeedFooterView: UIView {

    let likeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("👍", for: .normal)

        return button
    }()

    let dropButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = UIColor.red.withAlphaComponent(0.2).cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("❌", for: .normal)

        return button
    }()

    init() {
        super.init(frame: .zero)

        addSubviews()
        setUpLayout()
    }

    // MARK: - Subviews

    private func addSubviews() {
        addSubview(likeButton)
        addSubview(dropButton)
    }

    // MARK: - Layout

    private func setUpLayout() {
        likeButton.sizeAnchors == CGSize(width: 100, height: 40)
        likeButton.verticalAnchors == verticalAnchors
        likeButton.leadingAnchor == leadingAnchor

        dropButton.sizeAnchors == likeButton.sizeAnchors
        dropButton.verticalAnchors == likeButton.verticalAnchors
        dropButton.leadingAnchor == likeButton.trailingAnchor + 25
    }

    // MARK: - Required initializer

    required init?(coder _: NSCoder) { return nil }

}
