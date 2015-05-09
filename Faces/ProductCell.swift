import FacesUI

class ProductCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: HighlightedLabel!
    @IBOutlet weak var descLabel: NormalLabel!
    func configure(product:Product) {
        self.nameLabel.text = product.name
        self.descLabel.text = product.desc
        
        if let imageURL = product.image {
            self.imageView.sd_setImageWithURL(imageURL)
        }
    }
}
