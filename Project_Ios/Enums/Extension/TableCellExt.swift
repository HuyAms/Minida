import UIKit

extension UITableViewCell {
    
    @IBInspectable var normalBackgroundColor: UIColor? {
        get {
            return backgroundView?.backgroundColor
        }
        set(color) {
            let background = UIView()
            background.backgroundColor = color
            backgroundView = background
        }
    }
    
    @IBInspectable var selectedBackgroundColor: UIColor? {
        get {
            return selectedBackgroundView?.backgroundColor
        }
        set(color) {
            let background = UIView()
            background.backgroundColor = color
            selectedBackgroundView = background
        }
    }
}

