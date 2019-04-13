import Anchorage

public protocol PagerViewDelegate: AnyObject {
    func titleForPage() -> String
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
    
    struct Properties {
        let title: String
    }
    
    static let `default` = Properties(title: "")
    
    func render(_ properties: TagView.Properties) {
        
    }
}

final class TagBarView: UIView, ViewRendering {
    
    private class TagCell: WrapperCollectionViewCell<TagView> { }
    private let collection = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
    typealias Properties = [TagView.Properties]
    var properties: Properties = []
    
    func render(_ properties: [TagView.Properties]) {
        self.properties = properties
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collection)
        collection.edgeAnchors == edgeAnchors
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TagBarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return properties.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagView.identifier,
                                                            for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        return cell
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
        wrapped.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[wrapped]-0-|",
                                       options: [],
                                       metrics: [:],
                                       views: ["wrapped":wrapped])
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[wrapped]-0-|",
                                       options: [],
                                       metrics: [:],
                                       views: ["wrapped":wrapped])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class PagerViewController: UIViewController {
    
    private let tagBarView = TagBarView()
    private let pager = PagerView()
    
    override func viewDidLoad() {
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
    
    private let collection = UICollectionView(frame: .zero,
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
        collection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collection]-0-|",
                                       options: [],
                                       metrics: [:],
                                       views: ["collection":collection])
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collection]-0-|",
                                       options: [],
                                       metrics: [:],
                                       views: ["collection":collection])
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
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                       options: [],
                                       metrics: [:],
                                       views: ["view":view])
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                       options: [],
                                       metrics: [:],
                                       views: ["view":view])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
