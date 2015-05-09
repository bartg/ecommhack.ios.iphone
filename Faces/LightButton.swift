@IBDesignable public class LightButton: NormalButton {
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.styleLight()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.refreshRadius()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.styleLight()
        self.refreshRadius()
    }
    
    final func refreshRadius() {
        let newRadius = UI.percentageRadius * self.frame.height
        self.layer.cornerRadius = newRadius
    }
    
    final func styleLight() {
        self.backgroundColor = StyleKit.links
        self.setTitleColor(StyleKit.gray1, forState: UIControlState.Normal)
    }
}
