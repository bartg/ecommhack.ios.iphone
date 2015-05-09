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
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if isDebug() {
            DLOG("DEBUG MODE!")
        }
        self.styleAppearance()
        self.setUpSDK(launchOptions)
        self.setUpPayPal()
        
        // Set Up system wide used API
        self.api.delegate = self
        ((self.window?.rootViewController as! UINavigationController).viewControllers.last! as! FacesViewController).api = self.api
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func setUpPayPal() {
        PayPalMobile.initializeWithClientIdsForEnvironments(["PayPalEnvironmentSandbox":"AXI8ipekXnZ9C6Ph_2W5ivink3MRMu0WTroKIJPy8GlHs63ZYxfhUpqQJ59U3rMEXgfNjbWy2JyMj5eF"])
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
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation);
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    // MARK: Api Delegate
    
    func apiRespondedWithError(errorType: APIErrorType) {
        (self.window?.rootViewController as! UINavigationController).popToRootViewControllerAnimated(true)
    }
}


