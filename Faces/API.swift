import Foundation

enum APIErrorType {
    case Unauthenticated
}

protocol APIErrorDelegate {
    func apiRespondedWithError(errorType: APIErrorType)
}

class API:NSObject {
    dynamic var user:User!
    var delegate:APIErrorDelegate?
    
    override init() {
        super.init()
        let token = FXKeychain.defaultKeychain().objectForKey("token") as? String
        self.token = token
        self.updateToken()
        if isDebug() {
            RestKitObjC.initLogging()
        }
    }
    
    class func URL(method:String) -> String {
        return "\(method)/"
    }
    
    let manager:RKObjectManager = {
        let manager = RKObjectManager(baseURL: NSURL(string: API_URL))
        manager.requestSerializationMIMEType = RKMIMETypeJSON
        manager.HTTPClient.parameterEncoding = AFJSONParameterEncoding
        RestKitObjC.initLogging()
        RestKitObjC.setupTransformers()
        
        User.map(manager)
        Product.map(manager)
        
        return manager
        }()
    
    var token:String? {
        didSet {
            self.updateToken()
        }
    }
    
    var isLogged:Bool {
        get {
            return self.user != nil
        }
    }

    func updateToken() {
        if let token = self.token {
            self.manager.HTTPClient.setDefaultHeader("Authorization", value: "JWT \(token)")
        } else {
            self.manager.HTTPClient.setDefaultHeader("Authorization", value: nil)
        }
        FXKeychain.defaultKeychain().setObject(token, forKey: "token")
    }
    
    func fetchUser(success:()->(), failure:()->()) {
        if self.token != nil {
            self.manager.getObjectsAtPath("users/me/", parameters: [:], success: { [weak self] (operation, result) -> Void in
                if let user = result.firstObject as? User {
                    self?.user = user
                    success()
                }
                }, failure: { (operation, error) -> Void in
                    self.handleError(error, operation: operation.HTTPRequestOperation)
                    failure()
            })
        } else {
            failure()
        }
    }
    func authorizeWithFacebook(token:String, success:()->(), failure:()->()) {
        self.manager.postObject(nil, path: "auth/", parameters: ["type": "facebook", "access_token":token], success: { [weak self] (operation, result) -> Void in
            if let user = result.firstObject as? User {
                self?.user = user
                self?.token = user.accessToken
                user.accessToken = ""
                success()
            }
        }) { (operation, error) -> Void in
            self.handleError(error, operation: operation.HTTPRequestOperation)
            failure()
        }
    }
    
    func handleError(error:NSError, operation:AFHTTPRequestOperation? = nil) {
        if operation?.response?.statusCode == 401 {
            self.delegate?.apiRespondedWithError(.Unauthenticated)
        }
    }
    
    func logOut() {
        self.token = nil
        self.user = nil
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
}