class Product: Model {
    dynamic var name = ""
    dynamic var desc = ""
    dynamic var price = NSDecimalNumber(string: "0")
    dynamic var images = [Image]()
    
    class func map(manager:RKObjectManager) {
        let responseDescriptor = RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.GET, pathPattern: "products/recommendation/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful))
        manager.addResponseDescriptor(responseDescriptor)
        
    }
    
    class func mapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(forClass: self)
        mapping.addAttributeMappingsFromDictionary([
            "name": "name",
            "desc": "desc",
            "images": "imagesURL",
            ])
        mapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "images", toKeyPath: "images", withMapping: Image.mapping()))
        return mapping
    }
}
