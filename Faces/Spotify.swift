import Foundation

protocol SpotifyDelegate {
    func spotifylostPermissionToPlay(spotify:Spotify)
}

@objc(Spotify)
class Spotify:NSObject, SPTAudioStreamingPlaybackDelegate {
    var delegate:SpotifyDelegate?
    class var sharedInstance: Spotify {
        struct Static {
            static var instance: Spotify?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Spotify()
        }
        
        return Static.instance!
    }
    
    override init() {
        super.init()
        self.player.playbackDelegate = self
    }
    var spotifySession:SPTSession? {
        didSet {
            if let session = self.spotifySession {
                self.connectToPlayer(session)
            }
        }
    }
    var player:SPTAudioStreamingController = SPTAudioStreamingController(clientId: SPOTIFY_CLIENT_ID)
    
    func connectToPlayer(session:SPTSession) {
        self.player.loginWithSession(session, callback: { [weak self] (error) -> Void in
            if(error != nil) {
                DLOG("Got error when trying to login with session: \(error)")
            }
            return
        })
    }
    
    func playSongs(uris:[NSURL], index:Int32? = nil, callback:(()->())? = nil, failure:((error:NSError)->())? = nil) {
        let options = SPTPlayOptions()
        options.trackIndex = index ?? 0
        self.player.playURIs(uris, withOptions: options, callback: { (error) -> Void in
            if error != nil {
                DLOG("Got error when trying to play [\(uris)]: \(error)")
                failure?(error: error)
                return
            }
            callback?()
        })
    }
    
    func queueSongs(uris:[NSURL], index:Int32? = nil, callback:(()->())? = nil, failure:(()->())? = nil) {
        let options = SPTPlayOptions()
        options.trackIndex = index ?? 0
        
        self.player.queueURIs(uris, clearQueue: false) { (error) -> Void in
            if error != nil {
                DLOG("Got error when trying to play [\(uris)]: \(error)")
                failure?()
                return
            }
            callback?()
        }
    }
    
    func replaceSongs(uris:[NSURL], index:Int32? = nil, callback:(()->())? = nil) {
        self.player.replaceURIs(uris, withCurrentTrack: index!) { (error) -> Void in
            if error != nil {
                DLOG("Got error when trying to replace [\(uris)]: \(error)")
                return
            }
        }
    }
    func play() {
        self.player.setIsPlaying(true, callback: { (error) -> Void in
            
        })
    }
    
    func pause() {
        self.player.setIsPlaying(false, callback: { (error) -> Void in
            
        })
    }
    
    func stop(callback:(()->())? = nil) {
        self.player.stop { (error) -> Void in
            
        }
    }
    
    func next() {
        self.player.skipNext { (error) -> Void in
            
        }
    }
    
    func prev() {
        self.player.skipPrevious { (error) -> Void in
            
        }
    }
    
    dynamic var isPlaying:Bool = false
    func audioStreamingDidPopQueue(audioStreaming: SPTAudioStreamingController!) {
        DLOG("audioStreamingDidPopQueue")
    }
    
    private let racSubjectTrackFinished = RACSubject()
    var rac_trackFinished:RACSignal {
        return self.racSubjectTrackFinished as RACSignal
    }
    
    func audioStreamingDidSkipToNextTrack(audioStreaming: SPTAudioStreamingController!) {
        DLOG("audioStreamingDidSkipToNextTrack")
    }
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: NSURL!) {
        DLOG("didStopPlayingTrack: \(trackUri)")
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        self.isPlaying = isPlaying
    }
    
    dynamic var currentTrackURI:NSURL?
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangeToTrack trackMetadata: [NSObject : AnyObject]!) {
        if(trackMetadata != nil) {
            self.currentTrackURI = NSURL(string: (trackMetadata["SPTAudioStreamingMetadataTrackURI"] as? String) ?? "")
        } else {
            self.currentTrackURI = nil
        }
//        {
//            SPTAudioStreamingMetadataAlbumName = "Drunken Sailor";
//            SPTAudioStreamingMetadataAlbumURI = "spotify:album:5iyQuCFO65zkVXaqtBYFuo";
//            SPTAudioStreamingMetadataArtistName = "The Irish Rovers";
//            SPTAudioStreamingMetadataArtistURI = "spotify:artist:0tkKwWigaADLYB9HdFCjYo";
//            SPTAudioStreamingMetadataTrackDuration = "176.853";
//            SPTAudioStreamingMetadataTrackName = "Drunken Sailor";
//            SPTAudioStreamingMetadataTrackURI = "spotify:track:5Su5ILFp6U83cnIXwfmlC5";
//        }
        
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didFailToPlayTrack trackUri: NSURL!) {
        
    }
    
    func audioStreamingDidLosePermissionForPlayback(audioStreaming: SPTAudioStreamingController!) {
        self.isPlaying = false
        self.delegate?.spotifylostPermissionToPlay(self)
    }
    
}