import UIKit


extension UIColor {
    convenience init(hex: Int) {
        self.init(red: CGFloat((hex >> 16) & 0xff) / 255.0, green: CGFloat((hex >> 8) & 0xff) / 255.0, blue: CGFloat(hex & 0xff) / 255.0, alpha: 1)
    }
}


extension UIView {
    func addConstraints(format: String, views: UIView...) {
        var viewDict = [String: Any]()
        for(index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewDict[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
    }
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func showIndicator(size: Int) {
        showIndicator(size: size, color: UIColor.black)
    }
    
    func showIndicator(size: Int, color: UIColor) {
        let loadIndicator = UIActivityIndicatorView()
        loadIndicator.activityIndicatorViewStyle = .whiteLarge
        loadIndicator.color = color
        loadIndicator.startAnimating()
        var dimen = 20
        if size == 2 { dimen = 40 }
        if size == 3 { dimen = 60 }
        if size == 4 { dimen = 80 }
        if size == 5 { dimen = 100 }
        addSubview(loadIndicator)
        addConstraints(format: "V:|-(>=0)-[v0(\(dimen))]-(>=0)-|", views: loadIndicator)
        addConstraints(format: "H:|-(>=0)-[v0(\(dimen))]-(>=0)-|", views: loadIndicator)
        loadIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func hideIndicator() {
        for v: UIView in subviews {
            if v is UIActivityIndicatorView {
                v.removeFromSuperview()
            }
        }
    }
}


extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    }
    
    public func hideTransparentNavigationBar() {
        //        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
}


extension NSMutableAttributedString {
    @discardableResult func bold(_ text:String, size: CGFloat) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: size)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}

extension Encodable {
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension UIImage {
    
    func resize(_ size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        
        self.draw(in: CGRect(x:0, y:0, width:size.width, height:size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return newImage
    }
}

extension NSMutableData {
    
    func appendString(_ value : String) {
        let data = value.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
