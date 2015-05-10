class LinkLabel: NormalLabel {

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.styleLinkLabel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.styleLinkLabel()
    }
    
    func styleLinkLabel() {
        self.textColor = StyleKit.links
    }
}
