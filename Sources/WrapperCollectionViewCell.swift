import Anchorage

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
