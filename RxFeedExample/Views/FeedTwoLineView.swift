import Anchorage
import UIKit

class FeedTwoLineView: UIView {

    let topLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()

    let bottomLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        return label
    }()

    let container: UIStackView = {
        let container = UIStackView(frame: .zero)
        container.axis = .vertical
        container.distribution = .fill
        container.alignment = .fill
        container.spacing = 2.0
        return container
    }()

    init() {
        super.init(frame: .zero)

        addSubviews()
        setUpLayout()
    }

    // MARK: - Subviews

    private func addSubviews() {
        container.addArrangedSubview(topLabel)
        container.addArrangedSubview(bottomLabel)
        addSubview(container)
    }

    // MARK: - Layout

    private func setUpLayout() {
        container.edgeAnchors == edgeAnchors

        [topLabel, bottomLabel].forEach {
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
    }

    // MARK: - Required initializer

    required init?(coder _: NSCoder) { return nil }

}
