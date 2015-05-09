class Product: Model {
    var name = ""
    var desc = ""
    var imageURL = ""
    var image:NSURL? {
        return NSURL(string: self.imageURL)
    }
    
    class func map(manager:RKObjectManager) {
        let responseDescriptor = RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.GET, pathPattern: "products/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful))
        manager.addResponseDescriptor(responseDescriptor)
    }
    
    class func mapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(forClass: self)
        mapping.addAttributeMappingsFromDictionary([
            "name": "name",
            "desc": "desc",
            "image": "imageURL",
            ])
        return mapping
    }
}
