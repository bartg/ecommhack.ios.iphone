import UIKit

class Model: NSObject {
    var api:API!
    
    override init() {
        super.init()
    }
    
    convenience init(api:API) {
        self.init()
        self.api = api
    }
}
