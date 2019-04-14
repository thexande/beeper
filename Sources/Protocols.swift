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

extension UICollectionView {
    func register(_ cellType: UICollectionViewCell.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.identifier)
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

extension UICollectionViewCell: Reusable { }

protocol CollectionViewSectionController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static func register(with collection: UICollectionView)
}
