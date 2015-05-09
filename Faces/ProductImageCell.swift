
class ProductImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    func configure(imageURL:NSURL) {
        self.imageView.sd_setImageWithURL(imageURL)
    }
}
