@IBDesignable public class BackgroundView: UIView {
    @IBInspectable public var darker:Bool = false {
        didSet {
            self.styleIt()
        }
    }
    
    public override func prepareForInterfaceBuilder() {
        self.styleIt()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.styleIt()
    }
    
    final func styleIt() {
        self.backgroundColor = self.darker ? StyleKit.darkGrey : StyleKit.backgorund
    }
}
