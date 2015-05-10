
class ProductImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    func configure(image:Image) {
        self.imageView.sd_setImageWithURL(NSURL(string: image.smallUrl))

    }
}
