import Anchorage

public protocol PagerViewDelegate: AnyObject {
    func titleForPage(at index: Int) -> String
}

public protocol PagerViewDatasource: AnyObject {
    func view(for index: Int) -> UIView
    func numberOfPages() -> Int
}

protocol ViewRendering {
    associatedtype Properties
    func render(_ properties: Properties)
}

final class TagView: UIView, ViewRendering, Reusable {
    
    typealias Properties = String
    let title = UILabel()
    
    func render(_ properties: Properties) {
        title.text = properties
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        title.edgeAnchors == edgeAnchors
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TagSectionController: NSObject, CollectionViewSectionController {
    
    weak var delegate: PagerViewDelegate?
    weak var datasource: PagerViewDatasource?
    
    private final class Cell: WrapperCollectionViewCell<TagView> { }
    
    static func register(with collection: UICollectionView) {
        collection.register(Cell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfPages() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier,
                                                            for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        cell.wrapped.render(delegate?.titleForPage(at: indexPath.item) ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: collectionView.frame.height)
    }
}

extension UICollectionView {
    func register(_ cellType: UICollectionViewCell.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }
}

final class TagBarView: UIView, ViewRendering {
    
    private class TagCell: WrapperCollectionViewCell<TagView> { }
    let collection = UICollectionView(frame: .zero,
                                      collectionViewLayout: UICollectionViewFlowLayout())
    private let tagSection = TagSectionController()

    typealias Properties = [TagView.Properties]
    var properties: Properties = []
    
    public weak var delegate: PagerViewDelegate? {
        didSet {
            tagSection.delegate = delegate
        }
    }
    
    public weak var datasource: PagerViewDatasource? {
        didSet {
            tagSection.datasource = datasource
        }
    }
    
    
    func render(_ properties: [TagView.Properties]) {
        self.properties = properties
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collection)
        collection.delegate = tagSection
        collection.dataSource = tagSection
        collection.edgeAnchors == edgeAnchors
        TagSectionController.register(with: collection)
        
        (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

class WrapperCollectionViewCell<T: UIView & Reusable>: UICollectionViewCell {
    
    let wrapped = T()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(wrapped)
        wrapped.edgeAnchors == contentView.edgeAnchors
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class PagerViewController: UIViewController {
    
    private let tagBarView = TagBarView()
    private let pager = PagerView()
    
    public weak var delegate: PagerViewDelegate? {
        didSet {
            pager.delegate = delegate
            tagBarView.delegate = delegate
        }
    }
    
    public weak var datasource: PagerViewDatasource? {
        didSet {
            pager.datasource = datasource
            tagBarView.datasource = datasource
        }
    }
    
    public func reloadData() {
        pager.collection.reloadData()
        tagBarView.collection.reloadData()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    
        [tagBarView, pager].forEach {
            view.addSubview($0)
            $0.horizontalAnchors == view.horizontalAnchors
        }
        
        if #available(iOS 11.0, *) {
            tagBarView.topAnchor == view.safeAreaLayoutGuide.topAnchor
        } else {
            // Fallback on earlier versions
        }
        
        tagBarView.heightAnchor == 60
        
        pager.topAnchor == tagBarView.bottomAnchor
        pager.bottomAnchor == view.bottomAnchor
        
    }
    
}

public final class PagerView: UIView {
    
    let collection = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
    private let sectionController = PagerViewSectionController()
    
    public weak var delegate: PagerViewDelegate? {
        didSet {
            sectionController.delegate = delegate
        }
    }
    
    public weak var datasource: PagerViewDatasource? {
        didSet {
            sectionController.datasource = datasource
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collection)
        collection.delegate = sectionController
        collection.dataSource = sectionController
        collection.isPagingEnabled = true
        PagerViewSectionController.register(with: collection)
        collection.edgeAnchors == edgeAnchors
        
        (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UICollectionViewCell: Reusable { }

protocol CollectionViewSectionController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static func register(with collection: UICollectionView)
}

final class PagerViewSectionController: NSObject, CollectionViewSectionController {
    
    weak var delegate: PagerViewDelegate?
    weak var datasource: PagerViewDatasource?

    static func register(with collection: UICollectionView) {
        collection.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: UICollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfPages() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let view = datasource?.view(for: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.identifier, for: indexPath)
        cell.contentView.addSubview(view)
    
        view.edgeAnchors == cell.contentView.edgeAnchors
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
