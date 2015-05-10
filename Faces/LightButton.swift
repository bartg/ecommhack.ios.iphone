@IBDesignable public class LightButton: NormalButton {
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.styleLight()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.styleLight()
    }
    
    final func styleLight() {
        self.backgroundColor = StyleKit.links
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.layer.cornerRadius = 5.0
    }
}
