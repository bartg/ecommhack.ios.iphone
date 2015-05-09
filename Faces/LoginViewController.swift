import UIKit

class LoginViewController: FacesViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ga_title = "Login Screen"
        self.loginButton.delegate = self
        self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        RACObserve(self.api, "user").subscribeNextAs { [weak self] (user:User) -> () in
            self?.performSegueWithIdentifier("login", sender: self)
        }
        if !self.api.isLogged && FBSDKAccessToken.currentAccessToken() != nil {
            self.loginWithFacebook()
        } else if self.api.isLogged && self.api.user == nil {
            SVProgressHUD.showWithMaskType(.Black)
            self.api.fetchUser({ [weak self] () -> () in
                SVProgressHUD.dismiss()
            }, failure: { () -> () in
                SVProgressHUD.dismiss()
            })
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func loginWithFacebook() {
        let token = FBSDKAccessToken.currentAccessToken().tokenString
        SVProgressHUD.showWithMaskType(.Black)
        self.api.authorizeWithFacebook(token, success: { () -> () in
            SVProgressHUD.dismiss()
        }, failure: { () -> () in
            SVProgressHUD.dismiss()
        })
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        self.loginWithFacebook()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.api.logOut()
    }
    
    
    
    
}

