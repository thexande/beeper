import Anchorage

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

