//
//  Image.swift
//  Faces
//
//  Created by Michał Hernas on 10/05/15.
//  Copyright (c) 2015 Faces. All rights reserved.
//

import Foundation

class Image:Model {
    var smallUrl = ""
    var image:UIImage?
    
    class func mapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(forClass: self)
        mapping.addAttributeMappingsFromDictionary([
            "smallUrl": "smallUrl"
            ])
        return mapping
    }
    
    func downloadImage() {
        if let url = NSURL(string: self.smallUrl) {
            if let data = NSData(contentsOfURL: url) {
                self.image = UIImage(data: data)
            }
        }
    }
}