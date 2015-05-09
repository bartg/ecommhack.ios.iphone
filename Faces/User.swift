import UIKit

class User: Model {
    var accessToken = ""
    var userId = ""
    var name = ""
    var email = ""
    
    class func map(manager:RKObjectManager) {
        let responseDescriptor = RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.GET, pathPattern: "users/me/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful))
        manager.addResponseDescriptor(responseDescriptor)
        
        
        let reponseDescriptorAuth = RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.POST, pathPattern: "auth/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful))
        manager.addResponseDescriptor(reponseDescriptorAuth)
    }
    
    class func mapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(forClass: self)
        mapping.addAttributeMappingsFromDictionary([
            "access_token": "accessToken",
            "name": "name",
            "email": "email",
            ])
        return mapping
    }
}
