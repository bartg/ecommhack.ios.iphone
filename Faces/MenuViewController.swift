import UIKit
import FacesUI


class MenuViewController: FacesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ga_title = "Menu"

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    @IBAction func logOutTapped(sender: AnyObject) {
        self.api.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
