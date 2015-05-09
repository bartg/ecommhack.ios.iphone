@IBDesignable public class NormalButton: UIButton {
    @IBInspectable public var fontSize:CGFloat = UI.fontSize {
        didSet {
            self.styleIt()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.styleIt()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.styleIt()
    }
    
    final func styleIt() {
        self.titleLabel?.font = UI.fontSized(self.fontSize)
        self.tintColor = StyleKit.links
        self.setTitleColor(self.tintColor, forState: UIControlState.Normal)
    }

}
