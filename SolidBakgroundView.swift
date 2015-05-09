@IBDesignable class SolidBakgroundView: UIView {
    @IBInspectable public var lighter:Bool = false {
        didSet {
            self.styleIt()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.styleIt()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.styleIt()
    }
    
    final func styleIt() {
        if self.lighter {
            self.backgroundColor = StyleKit.dark3
        } else {
            self.backgroundColor = StyleKit.dark4
        }
    }
}
