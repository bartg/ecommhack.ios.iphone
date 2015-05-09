import UIKit
import FacesUI

class FacesViewController: UIViewController {
    var api:API!
    var _ga_title:String?
    var ga_title:String? {
        get {
            return self._ga_title ?? self.title
        }
        set {
            self._ga_title = newValue
        }
    }

    override func viewDidLoad() {
        assert(api != nil, "VC got nil API")
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? FacesViewController {
            dest.api = self.api
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        assert(self.ga_title != nil && !self.ga_title!.isEmpty, "View Controller doesnt have title, cannot track screen!")
        MXGoogleAnalytics.ga_trackScreen(self.ga_title!)
    }
}
