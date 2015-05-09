@IBDesignable public class BorderedButton: NormalButton {
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.styleBordered()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.refreshRadius()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.styleBordered()
        self.refreshRadius()
    }
    
    final func refreshRadius() {
        let newRadius = UI.percentageRadius * self.frame.height
        self.layer.cornerRadius = newRadius
    }
    
    final func styleBordered() {
        self.layer.borderColor = StyleKit.links.CGColor
        self.layer.borderWidth = UI.buttonBorderWidth
    }
}
