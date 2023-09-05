import UIKit

final class ViewFactory {
    static let shared = ViewFactory()
    
    func createTextLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.sfBold22
        return label
    }
    
    func createTextView() -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.sfRegular17
        textView.backgroundColor = UIColor.init(hexString: "F7F7F8")
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 10)
        return textView
    }
    
    func createNFTImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }
    
    func createLikeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heartButtonImage")
        return imageView
    }
}
