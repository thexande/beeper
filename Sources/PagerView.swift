import Anchorage

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
