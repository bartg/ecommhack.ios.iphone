import UIKit
import Crashlytics
import FacesUI
import AVFoundation
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, APIErrorDelegate {
    var spotifySession:SPTSession?
    var spotifyPlayer:SPTAudioStreamingController?
    
    var window: UIWindow?
    var api = API()
    
    let backgroundTask = TokenRefreshBackgroundTask()
    
    var audioPlayer = AVAudioPlayer()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if isDebug() {
            DLOG("DEBUG MODE!")
        }
        self.backgroundTask.api = self.api
        self.backgroundTask.start()
        
        self.styleAppearance()
        self.setUpSDK(launchOptions)
        self.setUpSpotify()
        
        // Set Up system wide used API
        self.api.delegate = self
        ((self.window?.rootViewController as! UINavigationController).viewControllers.last! as! FacesViewController).api = self.api
        return true
    }
    
    func setUpSpotify() {
        let auth = SPTAuth.defaultInstance()
        auth.tokenSwapURL = NSURL(string: SPOTIFY_TOKEN_SWAP_URL)
        auth.tokenRefreshURL = NSURL(string: SPOTIFY_TOKEN_REFRESH_URL)
        auth.redirectURL = NSURL(string: SPOTIFY_CALLBACK_URL)
        
        var setCategoryErr:NSError?
        var activationErr:NSError?
        if(AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: &setCategoryErr)) {
            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
            
            AVAudioSession.sharedInstance().setActive(true, error: &activationErr)
        } else {
            DLOG("AVAudioSession set category playback error: \(setCategoryErr)")
        }
    }
    
    func styleAppearance() {
        self.window?.tintColor = StyleKit.links
        
        // Navigation Bar
        let textAttributes = NSMutableDictionary(capacity:1)
        textAttributes.setObject(StyleKit.gray1, forKey: NSForegroundColorAttributeName)
        UINavigationBar.appearance().titleTextAttributes = textAttributes as [NSObject : AnyObject]
        
        
        //        YLProgressBar.appearance().type = .Flat
        //        YLProgressBar.appearance().tintColor = colorPurple
        //        YLProgressBar.appearance().progressTintColors = [colorPurple, colorPurple]
        //        YLProgressBar.appearance().hideStripes = true
        //        YLProgressBar.appearance().trackTintColor = colorDarkGrey

    }
    
    func setUpSDK(launchOptions: [NSObject: AnyObject]?) {
        // Crashlytics
        Crashlytics.startWithAPIKey("df45d086fdfbfa0fc287e23c9ad0a5dfb9a2182f")
        
        // Google Analytics
        MXGoogleAnalytics.ga_inicializeWithTrackingId("")
        MXGoogleAnalytics.ga_trackApplicationLauchingWithOptions(launchOptions)
        MXGoogleAnalytics.ga_allowIDFACollection(false)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        let auth = SPTAuth.defaultInstance()
        
        DLOG("Swap url: \(auth.tokenSwapURL), return url: \(auth.redirectURL)")
        if(auth.canHandleURL(url)) {
            auth.handleAuthCallbackWithTriggeredAuthURL(url, callback: { (error, session) -> Void in
                if error != nil {
                    DLOG("Got error: \(error)")
                    DLOG("Got session: \(session)")
                    return
                }
                if let session = session {
                    Spotify.sharedInstance.spotifySession = session

                    
                    var parseError: NSError?
                    let parsedObject = NSJSONSerialization.JSONObjectWithData(session.encryptedRefreshToken.dataUsingEncoding(NSUTF8StringEncoding)!,
                        options: NSJSONReadingOptions.AllowFragments,
                    error:&parseError) as? [String:AnyObject]
                    self.api.token = parsedObject?["token"] as? String
                    
                    self.api.fetchUser({ () -> () in
                        SVProgressHUD.dismiss()
                        }, failure: { () -> () in
                            SVProgressHUD.dismiss()
                    })
                    
                }
                return
            })
            return true
        }
        return true;
    }
    
    // MARK: Api Delegate
    
    func apiRespondedWithError(errorType: APIErrorType) {
        (self.window?.rootViewController as! UINavigationController).popToRootViewControllerAnimated(true)
    }
}


