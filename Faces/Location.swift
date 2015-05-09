import Foundation

class Location: Model {
    dynamic var currentTrack:Track?
    dynamic var nextTrack:Track?
    var name = ""
    var id = ""
    var slug = ""
    var owner:User!
    
    class func map(manager:RKObjectManager) {
        var responseDescriptors = [RKResponseDescriptor]()
        responseDescriptors.append(RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.POST, pathPattern: "locations/:id/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)))
        responseDescriptors.append(RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.POST, pathPattern: "locations/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)))
        responseDescriptors.append(RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.GET, pathPattern: "locations/:slug/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)))
        responseDescriptors.append(RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.GET, pathPattern: "locations/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)))
        responseDescriptors.append(RKResponseDescriptor(mapping: self.mapping(), method: RKRequestMethod.POST, pathPattern: "locations/actions/next/", keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)))
        manager.addResponseDescriptorsFromArray(responseDescriptors)
    }
    
    class func mapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(forClass: self)
        mapping.addAttributeMappingsFromDictionary([
            "name": "name",
            "slug": "slug"
            ])
        mapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "current_track", toKeyPath: "currentTrack", withMapping: Track.mapping()))
        mapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "next_track", toKeyPath: "nextTrack", withMapping: Track.mapping()))
        mapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "owned_by", toKeyPath: "owner", withMapping: User.mapping()))
        return mapping
    }
    
    class func create(api:API) -> RACSignal {
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            let request = api.manager.HTTPClient.requestWithMethod("POST", path: "locations/", parameters: [:])
            let operation = api.manager.objectRequestOperationWithRequest(request, success: { (operation, results) -> Void in
                subscriber.sendNext(results.firstObject)
            }, failure: { (operation, error) -> Void in
                api.handleError(error, operation: operation.HTTPRequestOperation)
                subscriber.sendError(error)
            })
            api.manager.enqueueObjectRequestOperation(operation)
            return nil
        }).deliverOnMainThread()
    }
    
    
    class func join(api:API, slug:String) -> RACSignal {
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            let request = api.manager.HTTPClient.requestWithMethod("POST", path: "locations/\(slug)/", parameters: [:])
            let operation = api.manager.objectRequestOperationWithRequest(request, success: { (operation, results) -> Void in
                subscriber.sendNext(results.firstObject)
                subscriber.sendCompleted()
                }, failure: { (operation, error) -> Void in
                    api.handleError(error, operation: operation.HTTPRequestOperation)
                    subscriber.sendError(error)
            })
            api.manager.enqueueObjectRequestOperation(operation)
            return nil
        }).deliverOnMainThread()
    }
    
    func nextTrack(api:API) -> RACSignal {
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            api.manager.postObject(self, path: "locations/actions/next/", parameters: [:], success: { [weak self] (operation, result) -> Void in
                subscriber.sendNext(self)
                subscriber.sendCompleted()
                return
                }, failure: { (operation, error) -> Void in
                    api.handleError(error, operation: operation.HTTPRequestOperation)
                    subscriber.sendError(error)
            })
            return nil
        }).deliverOnMainThread()
    }
    
    func get(api:API) -> RACSignal {
        DLOG("Refreshing location \(self.slug)")
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            api.manager.getObject(self, path: "locations/\(self.slug)/", parameters: [:], success: { [weak self] (operation, result) -> Void in
                subscriber.sendNext(self)
                subscriber.sendCompleted()
                }, failure: { (operation, error) -> Void in
                    api.handleError(error, operation: operation.HTTPRequestOperation)
                    subscriber.sendError(error)
            })
            return nil
        }).deliverOnMainThread()
    }
    
    func refreshOwned(api:API) -> RACSignal {
        DLOG("Refreshing own location \(self.slug)")
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            api.manager.getObject(self, path: "locations/", parameters: [:], success: { [weak self] (operation, result) -> Void in
                subscriber.sendNext(self)
                subscriber.sendCompleted()
                }, failure: { (operation, error) -> Void in
                    api.handleError(error, operation: operation.HTTPRequestOperation)
                    subscriber.sendError(error)
            })
            return nil
        }).deliverOnMainThread()
    }
}