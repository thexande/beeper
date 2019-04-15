final class TagSectionController: NSObject, CollectionViewSectionController {
    
    weak var delegate: PagerViewDelegate?
    weak var datasource: PagerViewDatasource?
    var inset: UIEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
    
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
        let title = delegate?.titleForPage(at: indexPath.item) ?? ""
        cell.wrapped.render(.init(title: title,
                                  selection: .unselected))
        cell.wrapped.layoutMargins = inset
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = delegate?.titleForPage(at: indexPath.item) ?? ""
        let width = title.size(withAttributes:[.font: UIFont.systemFont(ofSize: 18)]).width + inset.left + inset.right
        return .init(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


protocol Paging: AnyObject {
    func pageDidChange(to index: Int)
    
}

final class PagingCoordinator {
    weak var tab: Paging?
    weak var pager: Paging?
}
