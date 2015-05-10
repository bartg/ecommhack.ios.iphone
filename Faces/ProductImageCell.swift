
class ProductImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    func configure(image:Image) {
        self.imageView.image = image.image
    }
}
