@IBDesignable public class NormalTextField: UITextField {
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.styleIt()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.styleIt()
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.refreshRadius()
    }
    
    
    final func styleIt() {
        self.borderStyle = UITextBorderStyle.None
        self.layer.masksToBounds = true
        self.backgroundColor = StyleKit.white
        self.textColor = StyleKit.dark4
        self.font = UI.fontSized(UI.fontSize)
        self.refreshRadius()
    }
    
    final func refreshRadius() {
        let newRadius = UI.percentageRadius * self.frame.height
        self.layer.cornerRadius = newRadius
    }
}
