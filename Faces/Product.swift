class Product: Model {
    dynamic var name = ""
    dynamic var desc = ""
    var imagesURL:[String] = [String]() {
        didSet {
            var images = [NSURL]()
            for img in imagesURL {
                images.append(NSURL(string: img)!)
            }
            self.images = images
        }
    }
    
    dynamic var images = [NSURL]()
    
    class func map(manager:RKObjectManager) {
        let responseDescriptor = RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.GET, pathPattern: "products/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful))
        manager.addResponseDescriptor(responseDescriptor)
    }
    
    class func mapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(forClass: self)
        mapping.addAttributeMappingsFromDictionary([
            "name": "name",
            "desc": "desc",
            "images": "imagesURL",
            ])
        return mapping
    }
}
