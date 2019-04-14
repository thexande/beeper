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
