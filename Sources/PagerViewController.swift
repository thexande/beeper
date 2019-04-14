import Anchorage

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
