import Anchorage

final class TagView: UIView, ViewRendering, Reusable {
    
    typealias Properties = String
    let title = UILabel()
    
    func render(_ properties: Properties) {
        title.text = properties
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        title.edgeAnchors == edgeAnchors
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
