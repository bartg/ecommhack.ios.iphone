import UIKit

class Player: NSObject {
    var tracks:[Track] {
        didSet {
            Spotify.sharedInstance.playSongs(self.tracks.map({$0.url}))
        }
    }
    dynamic var isPlaying:Bool = false {
        didSet {
            self.refreshTrackPosition()
        }
    }
    dynamic var currentSong:Track? {
        didSet {
            self.refreshTrackPosition()
        }
    }
    dynamic var currentIndex:Int = 0
    dynamic var currentPlaybackPosition:CGFloat = 0
    
    var shuffle:Bool = false {
        didSet {
            Spotify.sharedInstance.player.shuffle = self.shuffle
        }
    }
    var repeat:Bool = true {
        didSet {
            Spotify.sharedInstance.player.repeat = self.repeat
        }
    }
    
    init(_ tracks:[Track]) {
        self.tracks = tracks
        super.init()
        Spotify.sharedInstance.player.repeat = self.repeat
        Spotify.sharedInstance.player.shuffle = self.shuffle
        
        if count(self.tracks) > 0 {
            Spotify.sharedInstance.playSongs(self.tracks.map({$0.url}))
        }
        
        RACObserve(Spotify.sharedInstance, "isPlaying").subscribeNext { [weak self] (isPlaying) -> Void in
            self?.isPlaying = (isPlaying as! NSNumber).boolValue
            return
        }
        
        RACObserve(Spotify.sharedInstance, "currentTrackURI").subscribeNext { [weak self] (currentTrackURI) -> Void in
            
            if let currentTrackURI = currentTrackURI as? NSURL {
                
                if let weakSelf = self {
                    println(Spotify.sharedInstance.player.currentTrackIndex)
                    for (index, track) in enumerate(weakSelf.tracks) {
                        if track.url == currentTrackURI {
                            weakSelf.currentIndex = index
                            weakSelf.currentSong = track
                        }
                    }
                }
            }
            return
        }
        
        
        RACSignal.interval(0.3, onScheduler: RACScheduler.mainThreadScheduler()).takeUntil(self.rac_willDeallocSignal()).subscribeNext({ [weak self] (date) -> Void in
            self?.refreshTrackPosition()
            return
        })
    }
    
    func refreshTrackPosition() {
        if let song = self.currentSong {
            self.currentPlaybackPosition = CGFloat(Spotify.sharedInstance.player.currentPlaybackPosition) / CGFloat(song.duration)
        } else {
            self.currentPlaybackPosition = 0
        }
    }
    
    func next() {
        Spotify.sharedInstance.next()
    }
    
    func prev() {
        Spotify.sharedInstance.prev()
    }
    
    func toggle() {
        if self.isPlaying {
            self.pause()
        } else {
            self.play()
        }
    }
    
    func pause() {
        Spotify.sharedInstance.pause()
    }
    
    func play(index:Int) {
        Spotify.sharedInstance.replaceSongs(self.tracks.map({$0.url}), index: Int32(index-1))
        self.next()
    }
    
    func play() {
        Spotify.sharedInstance.play()
    }
    
    deinit {
        Spotify.sharedInstance.stop()
    }
}
