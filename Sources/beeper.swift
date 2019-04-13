
protocol PagerViewDelegate {
    
}

protocol PagerViewDatasource {
    func view(for index: Int) -> UIView
    func numberOfPages() -> Int
    func titleForPage() -> String
}

final class TabBarView: UICollectionView {
    
}

public final class PagerView: UIView {
    
}



