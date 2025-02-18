//
//  StyleKit.swift
//  Faces
//
//  Created by Faces on 10.05.2015.
//  Copyright (c) 2015 Faces. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class StyleKit : NSObject {

    //// Cache

    private struct Cache {
        static var links: UIColor = UIColor(red: 0.161, green: 0.533, blue: 0.298, alpha: 1.000)
        static var backgorund: UIColor = UIColor(red: 0.110, green: 0.196, blue: 0.290, alpha: 1.000)
        static var darkGrey: UIColor = UIColor(red: 0.157, green: 0.290, blue: 0.400, alpha: 1.000)
        static var grey: UIColor = UIColor(red: 0.267, green: 0.392, blue: 0.518, alpha: 1.000)
        static var lighGrey: UIColor = UIColor(red: 0.298, green: 0.420, blue: 0.569, alpha: 1.000)
    }

    //// Colors

    public class var links: UIColor { return Cache.links }
    public class var backgorund: UIColor { return Cache.backgorund }
    public class var darkGrey: UIColor { return Cache.darkGrey }
    public class var grey: UIColor { return Cache.grey }
    public class var lighGrey: UIColor { return Cache.lighGrey }

    //// Drawing Methods

    public class func drawBackground1(#frame: CGRect) {

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(frame.minX, frame.minY, frame.width, frame.height))
        StyleKit.backgorund.setFill()
        rectanglePath.fill()
    }

}

@objc protocol StyleKitSettableImage {
    func setImage(image: UIImage!)
}

@objc protocol StyleKitSettableSelectedImage {
    func setSelectedImage(image: UIImage!)
}
