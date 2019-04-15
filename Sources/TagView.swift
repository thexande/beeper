import Anchorage

final class TagView: UIView, ViewRendering, Reusable {
    
    struct Properties {
        enum Selection {
            case selected
            case unselected
        }
        
        let title: String
        let selection: Selection
    }
    
    let title = UILabel()
    
    func render(_ properties: Properties) {
        title.text = properties.title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        title.edgeAnchors == layoutMarginsGuide.edgeAnchors
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
