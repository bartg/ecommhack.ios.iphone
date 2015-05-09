@IBDesignable public class BackgroundView: UIView {
    override public func drawRect(rect: CGRect) {
        StyleKit.drawBackground1(frame: rect)
    }
}
