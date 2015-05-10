class Product: Model {
    dynamic var name = ""
    dynamic var desc = ""
    dynamic var brand = ""
    dynamic var productId = ""
    dynamic var price = NSDecimalNumber(string: "0")
    var priceString = "" {
        didSet {
            self.price = NSDecimalNumber(string: self.priceString)
        }
    }
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
            "price": "priceString",
            "brand": "brand"
            ])
        mapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "images", toKeyPath: "images", withMapping: Image.mapping()))
        return mapping
    }
}
