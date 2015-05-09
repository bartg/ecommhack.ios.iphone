@IBDesignable public class NormalLabel: UILabel {
    @IBInspectable public var fontSize:CGFloat = UI.fontSize {
        didSet {
            self.styleIt()
        }
    }
    @IBInspectable public var fontBold:Bool = false {
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
        self.font = UI.fontSized(self.fontSize, bold: self.fontBold)
        self.textColor = StyleKit.gray1
    }
}
