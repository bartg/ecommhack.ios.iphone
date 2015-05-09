@IBDesignable public class HighlightedLabel: UILabel {
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.styleHightlighted()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.styleHightlighted()
    }
    
    final func styleHightlighted() {
        self.font = UI.fontSized(UI.fontSizeSmall)
        self.textColor = StyleKit.notification
        self.backgroundColor = StyleKit.dark1
    }
}
