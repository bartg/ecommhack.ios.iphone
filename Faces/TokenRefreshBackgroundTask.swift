import Foundation

class TokenRefreshBackgroundTask {
    let periodOfTime:Double = 5*60
    var api:API?
    var canceled = false
    func start() {
        self.loop()
    }
    
    func loop() {
        if canceled {
            return
        }
        
        self.perform()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(periodOfTime * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { [weak self] () -> () in
            self?.loop()
            return
        })
    }
    
    func perform() {
        
        let littleBeInAPast = NSDate().dateByAddingTimeInterval(-periodOfTime)
        
        if self.api?.user != nil {
            let session = self.api!.user!.spotifySession()
            if littleBeInAPast.compare(session.expirationDate) == NSComparisonResult.OrderedDescending {
                self.api?.renewSession({ [weak self] (session) -> () in
                    Spotify.sharedInstance.spotifySession = session
                    }, failure: { (error) -> () in
                })
            }
        }
    }
    
    func cancel() {
        self.canceled = true
    }
}