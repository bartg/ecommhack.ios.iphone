public class UI: NSObject {
    public static let percentageRadius:CGFloat = 0.5
    public static let buttonBorderWidth:CGFloat = 1
    public static let fontNameRegular = "HelveticaNeue"
    public static let fontNameBold = "HelveticaNeue-Bold"
    public static let fontSize:CGFloat = 17
    public static let fontSizeSmall:CGFloat = 12
    public static let fontSizeBig:CGFloat = 34
    public static let font = UI.fontSized(UI.fontSize)
    
    public static func fontSized(size:CGFloat, bold:Bool = false) -> UIFont {
        let font = bold ? fontNameBold : fontNameRegular
        return UIFont(name: font, size: size)!
    }
}
