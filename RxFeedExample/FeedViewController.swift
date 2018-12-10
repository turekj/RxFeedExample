import AlamofireImage
import RxCocoa
import RxDataSources
import RxFeedback
import RxSwift
import UIKit

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    init() {
        super.init(collectionViewLayout: flowLayout)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCollectionView()
        setUpFeedbackLoop()
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = state.value?.items[indexPath.row] else {
            return .zero
        }

        if let size = sizes[item.id] {
            return size
        }

        present(item: item, in: layoutCell)
        let size = layoutCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        sizes[item.id] = size
        return size
    }

    // MARK: - Private

    private let provider: FeedProvider = FeedProvider(pageSize: 20)
    private lazy var layoutCell: FeedCell = FeedCell(frame: .zero)
    private var sizes: [Int: CGSize] = [:]
    private let state: BehaviorRelay<FeedState?> = BehaviorRelay(value: nil)
    private let mutations: PublishRelay<FeedMutation> = PublishRelay()
    private let disposeBag: DisposeBag = DisposeBag()

    private func setUpCollectionView() {
        collectionView?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.dataSource = nil
        collectionView?.delegate = self
    }

    private func setUpFeedbackLoop() {
        let uiFeedback: FeedState.Feedback = bind(self) { me, state in
            let subscriptions: [Disposable] = [
                me.bindDataSource(state: state, to: me.collectionView!)
            ]

            let mutations: [Signal<FeedMutation>] = [
                me.nextPageMutation(state: state, in: me.collectionView!),
                me.mutations.asSignal()
            ]


            return Bindings(subscriptions: subscriptions, mutations: mutations)
        }

        let loadPageFeedback: FeedState.Feedback = react(
            query: { $0.loadPageIndex },
            effects: { [provider] pageIndex -> Signal<FeedMutation> in
                provider.fetchPage(atIndex: pageIndex)
                    .map { .pageLoaded(page: $0) }
                    .asSignal(onErrorJustReturn: .error)
            }
        )

        Driver.system(
            initialState: FeedState(),
            reduce: FeedState.reduce,
            feedback: uiFeedback, loadPageFeedback
            )
            .drive(state)
            .disposed(by: disposeBag)
    }

    private func bindDataSource(state: Driver<FeedState>, to collectionView: UICollectionView) -> Disposable {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, FeedItem>>(
            configureCell: { [weak self] (_, collectionView, indexPath, item: FeedItem) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

                if let feedCell = cell as? FeedCell {
                    self?.present(item: item, in: feedCell)
                }

                return cell

            },
            configureSupplementaryView: { _, _, _, _ in UICollectionReusableView(frame: .zero) }
        )

        return state
            .map { $0.items }
            .map { [AnimatableSectionModel(model: "section", items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
    }

    private func nextPageMutation(state: Driver<FeedState>,
                                  in collectionView: UICollectionView) -> Signal<FeedMutation> {
        return state.flatMapLatest { state in
            guard !state.shouldLoadNext else {
                return Signal.empty()
            }

            return collectionView.rx.willDisplayCell
                .asSignal()
                .filter { $0.at.item == state.items.count - 1 }
                .map { _ in .loadNextPage }
        }
    }

    private func present(item: FeedItem, in cell: FeedCell) {
        cell.widthConstraint?.constant = collectionView.map { $0.bounds.width - 40.0 } ?? 0.0
        cell.postLabel.text = item.title
        cell.postImage.af_setImage(withURL: item.image)
        cell.headerView.author.topLabel.text = item.author
        cell.headerView.author.bottomLabel.text = item.whenCreated
        cell.headerView.distance.topLabel.text = item.distance
        cell.headerView.distance.bottomLabel.text = item.address
        cell.headerView.avatar.af_setImage(withURL: item.avatar)
        cell.footerView.likeButton.setTitle(item.liked ? "👎" : "👍", for: .normal)

        cell.footerView.likeButton.rx.tap
            .map { .like(id: item.id) }
            .bind(to: mutations)
            .disposed(by: cell.disposeBag)

        cell.footerView.dropButton.rx.tap
            .map { .drop(id: item.id) }
            .bind(to: mutations)
            .disposed(by: cell.disposeBag)
    }

    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 45, right: 0)
        return layout
    }()

    // MARK: - Required initializer

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
