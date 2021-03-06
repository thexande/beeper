import Anchorage

final class TagBarView: UIView, ViewRendering {
    
    public struct Configuration {
        let tagFont: UIFont
        let tagTextColor: UIColor
        let tagInset: UIEdgeInsets
        
        public init(tagFont: UIFont, tagTextColor: UIColor, tagInset: UIEdgeInsets) {
            self.tagFont = tagFont
            self.tagTextColor = tagTextColor
            self.tagInset = tagInset
        }
    }
    
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
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        TagSectionController.register(with: collection)
        
        (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
