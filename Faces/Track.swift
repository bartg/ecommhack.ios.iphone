import UIKit
import MediaPlayer

@objc(Track)
class Track: Model, Equatable, Printable  {
    var spotifyId:String?
    var title:String?
    var sharklistId:NSNumber?
    var durationMs:Double = 0
    var duration:Double {
        get {
            return self.durationMs / 1000
        }
    }
    var artistName:String?
    var imageUrlString:String? {
        didSet {
            if let url = self.imageUrlString {
                self.imageUrl = NSURL(string: url)
            }
        }
    }
    
    var imageUrl:NSURL?
    var url:NSURL {
        get {
            return NSURL(string: "spotify:track:\(self.spotifyId!)")!
        }
    }
    
    class func mapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(forClass: self)
        mapping.addAttributeMappingsFromDictionary([
            "spotify_id": "spotifyId",
            "id": "sharklistId",
            "title": "title",
            "duration_ms": "durationMs",
            "artist_name": "artistName",
            "image_url": "imageUrlString"
            ])
        
        return mapping
    }
    override func validateValue(ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKeyPath inKeyPath: String, error outError: NSErrorPointer) -> Bool {
        if let memory = ioValue.memory {
            if (inKeyPath == "imageUrlString" || inKeyPath == "title" || inKeyPath == "artistName") && ioValue.memory is NSNull {
                ioValue.memory = nil
                return true
            }
        }
        return super.validateValue(ioValue, forKeyPath: inKeyPath, error: outError)
    }
    
    override var description: String {
        get {
            return "[Track: \(self.spotifyId)]"
        }
    }
    // ObjC compatibility
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? Track {
            return self == object
        } else {
            return false
        }
    }
    
    
    func saveTrack(api:API) -> RACSignal {
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            api.manager.HTTPClient.postPath("playlist/track/\(self.sharklistId!)/save/", parameters: [:], success: { [weak self] (operation, results) -> Void in
                subscriber.sendNext(self)
                subscriber.sendCompleted()
                return
                }, failure: { (operation, error) -> Void in
                    api.handleError(error, operation: operation)
                    subscriber.sendError(error)
            })
            return nil
        }).deliverOnMainThread()
    }
    
    func showInMetadata() {
        let updateNowPlaying = { (image:UIImage?) -> () in
            var currentlyPlayingInfoTrack:[String:AnyObject] = [
                MPMediaItemPropertyTitle: self.title ?? "Undefined",
                MPNowPlayingInfoPropertyPlaybackRate: 1.0,
                MPMediaItemPropertyPlaybackDuration: self.duration
            ]
            if let artistName = self.artistName {
                currentlyPlayingInfoTrack[MPMediaItemPropertyArtist] = artistName
            }
            if let image = image {
                let artwork = MPMediaItemArtwork(image: image)
                currentlyPlayingInfoTrack[MPMediaItemPropertyArtwork] = artwork
            }
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = currentlyPlayingInfoTrack
        }
        if let imageUrl = self.imageUrl {
            SDWebImageManager.sharedManager().downloadImageWithURL(self.imageUrl!, options: nil, progress: nil) { (image, error, cacheType, success, url) -> Void in
                updateNowPlaying(image)
            }
        } else {
            updateNowPlaying(nil)
        }
    }
}

func ==(lhs: Track, rhs: Track) -> Bool {
    return lhs.spotifyId == rhs.spotifyId
}
