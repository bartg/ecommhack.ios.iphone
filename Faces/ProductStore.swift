class ProductStore: NSObject {
    private var data = [Product]()
    
    var count:UInt {
        return UInt(self.data.count)
    }
    
    subscript(indexPath:NSIndexPath) -> Product? {
        get {
            return self.data[indexPath.row]
        }
    }
    
    func append(product:Product) {
        self.data.append(product)
    }
}
