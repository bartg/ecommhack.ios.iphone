import UIKit

class User: Model {
    var accessToken = ""
    var tokenType = ""
    var expiresIn:NSTimeInterval = 0
    var expiresAt:NSDate!
    var refreshToken = ""
    var userId = ""
    var name = ""
    var email = ""
    var country = ""
    var followers = 0
    var avatarUrlString:String? {
        didSet {
            self.avatarURL = NSURL(string: self.avatarUrlString ?? "")
        }
    }
    var avatarURL:NSURL?
    var currentLocation:Location?
    var ownedLocation:Location?
    
    
    class func map(manager:RKObjectManager) {
        manager.addResponseDescriptor(self.responseDescriptor())
    }
    
    class func responseDescriptor() -> RKResponseDescriptor {
        let responseDescriptor = RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.GET, pathPattern: "users/me/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful))
        
        return responseDescriptor
    }
    
    class func mapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(forClass: self)
        mapping.addAttributeMappingsFromDictionary([
            "access_token": "accessToken",
            "token_type": "tokenType",
            "expires_in": "expiresIn",
            "expires_at": "expiresAt",
            "refresh_token": "refreshToken",
            "name": "name",
            "email": "email",
            "country": "country",
            "followers": "followers",
            "avatar_url": "avatarUrlString",
            "external_id": "userId",
            ])
        mapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "current_location", toKeyPath: "currentLocation", withMapping: Track.mapping()))
        mapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "owned_location", toKeyPath: "ownedLocation", withMapping: Track.mapping()))
        return mapping
    }
    
    func spotifySession() -> SPTSession {
        return SPTSession(userName: self.userId, accessToken: self.accessToken, encryptedRefreshToken: self.refreshToken, expirationDate: self.expiresAt)
    }
    
}
