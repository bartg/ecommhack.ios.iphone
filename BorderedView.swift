@IBDesignable public class BorderedView: UIImageView {
    public override func prepareForInterfaceBuilder() {
        self.styleIt()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.styleIt()
    }
    
    final func styleIt() {
        self.layer.borderColor = StyleKit.links.CGColor
        self.layer.borderWidth = 3.0
    }
}
