import UIKit
import FacesUI


class ProductsViewController: FacesViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var userHelloLabel: HighlightedLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userImageView: UIImageView!
    
    lazy var store = ProductStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ga_title = "Products"
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let product = Product()
        product.name = "iPhone 4"
        product.desc = "asdsda sad asdasd  sdad"
        product.imageURL = "http://faces.hern.as/static/images/david_hasselhoff_3.jpg"
        self.store.append(product)
        let product2 = Product()
        product2.name = "Apple"
        product2.desc = "asjhkdais  aisjdhasdhaskjdn asdjasnkda sdjaskd naslkd asmd;alsd"
        product2.imageURL = "http://www.justvape247.com/ekmps/shops/justvape247/images/-NEW-IN-RED-APPLE-NATURAL-FW--16946-p.jpg"
        self.store.append(product2)
        
        
        self.userHelloLabel.text = "Hi \(self.api.user.name)!"
        if let image = self.api.user.avatar {
            self.userImageView.sd_setImageWithURL(image)
        }
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("productCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        if let cell = cell as? ProductCell, product = self.store[indexPath] {
            cell.configure(product)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(self.store.count)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.collectionView.frame.size
    }
}