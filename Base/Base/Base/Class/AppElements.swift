
import Foundation
import UIKit
import SkyFloatingLabelTextField

public enum UserListType: String {
    
    case following = "followings"
    case followers = "followers"

    
    func title() -> String{
        
        switch self {
        case .followers:
            return "Takip Eden".localized()
        case .following:
            return "Takip Ettiği".localized()
        }
        
        
    }
}

public enum EventListType: String {
    
    case profile = "profile"
    
    func title() -> String{
        
        switch self {
        case .profile:
            return "Lorem".localized()
        }
        
        
    }
}

public enum ChallengeListType: String {
    
    case user = "user"
    case last = "last"
    case point = "point"
    case km = "km"
    
}

class RedButton: UIButton {
    
    var title: String!
    var titleFont = AppFont.Regular.pt16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.titleLabel?.font = titleFont
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.lightGray, for: .highlighted)
        self.setTitle(title, for: .normal)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.5
        self.layer.backgroundColor = UIColor.pinkred.cgColor
        
        self.addTextSpacing(4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BlackButton: UIButton {
    
    var title: String!
    var titleFont = AppFont.Regular.pt16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.titleLabel?.font = titleFont
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.lightGray, for: .highlighted)
        self.setTitle(title, for: .normal)
        self.layer.backgroundColor = UIColor.black.cgColor
        
        self.addTextSpacing(4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SteelBorderButton: UIButton {
    
    var title: String!
    var titleFont = AppFont.Regular.pt16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.titleLabel?.font = titleFont
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.steel.cgColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true
        self.setTitleColor(UIColor.steel, for: .normal)
        self.setTitleColor(UIColor.black, for: .highlighted)
        self.setTitle(title, for: .normal)
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        self.addTextSpacing(4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class FacebookButton: UIButton {
    
    var title: String!
    var titleFont = AppFont.Regular.pt16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.titleLabel?.font = titleFont
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.lightGray, for: .highlighted)
        self.setTitle(title, for: .normal)
        self.setImage(#imageLiteral(resourceName: "iconFacebookWhite"), for: .normal)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.5
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 20)
        self.layer.backgroundColor = UIColor.facebook.cgColor
        
        self.addTextSpacing(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CleanButton: UIButton {
    
    var title: String!
    var titleFont = AppFont.ExtraLight.pt14
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.titleLabel?.font = titleFont
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.lightGray, for: .highlighted)
        self.setTitle(title, for: .normal)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.5
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        self.addTextSpacing(1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LoginTextField: SkyFloatingLabelTextField {
    
    var arrow = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleFormatter = { $0 }
        self.arrow.isHidden = true
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }
    
    override func draw(_ rect: CGRect) {
        
        self.tintColor = .white
        self.placeholderFont = AppFont.Regular.pt16
        self.placeholderColor = UIColor.white.withAlphaComponent(0.5)
        self.titleFont = AppFont.Regular.pt10
        self.titleColor = UIColor.white.withAlphaComponent(0.5)
        self.textColor = UIColor.white
        self.lineColor = UIColor.white.withAlphaComponent(0.5)
        self.selectedLineColor = UIColor.white
        self.selectedTitleColor = UIColor.white
        self.clipsToBounds = false
        
        self.arrow.frame = CGRect(x: rect.size.width-20, y: 30, width: 20, height: 10)
        self.arrow.image = #imageLiteral(resourceName: "arrowDownWhite")
        self.arrow.contentMode = .scaleAspectFit
        self.addSubview(arrow)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProfilePhotoButton: UIView {
    
    var circle = UIView(forAutoLayout: ())
    var button = UIButton()
    var imageView = UIImageView()
    var tmpImage = UIImage()
    var circleColor = UIColor.clear
    var user : User!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.imageView.image = #imageLiteral(resourceName: "profilePhoto")
        self.imageView.contentMode = .scaleAspectFill
    }
    
    override func draw(_ rect: CGRect) {
        
        self.circle.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        self.circle.cornerRadius = self.frame.width/2
        self.circle.borderWidth = 1.0
        self.circle.borderColor = circleColor
        self.addSubview(circle)
        
        self.imageView.frame = CGRect(x: 4, y: 4, width: rect.size.width-8, height: rect.size.width-8)
        self.imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.cornerRadius = (self.frame.width-8)/2
        self.imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        self.button.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        self.addSubview(button)
        
    }
    
    func setCircleColor(color: UIColor) {
        self.circle.borderColor = color
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class helloView: UIView {
    
    var title: String!
    var profile: UIImageView!
    var dot: UIImageView!
    var nameLabel: UILabel!
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.setObserver(self, selector: #selector(self.updateDot), name: NSNotification.Name(rawValue: "updateUnreadCount"), object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(self.updateProfile), name: NSNotification.Name(rawValue: "profileUpdateNotif"), object: nil)
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        titleView.backgroundColor = UIColor.white
        
        let helloLabel = UILabel(frame: CGRect(x: 10, y: 2, width: screenSize.width-100, height: 12))
        helloLabel.font = AppFont.Regular.pt12
        helloLabel.textColor = UIColor.steel
        helloLabel.text = "Hello".localized()
        titleView.addSubview(helloLabel)
        
        nameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: screenSize.width-100, height: 34))
        nameLabel.font = AppFont.ExtraBold.pt26
        nameLabel.textColor = UIColor.black
        nameLabel.text = AppCache.sharedInstance.user.name
        titleView.addSubview(nameLabel)
        
        profile = UIImageView(frame: CGRect(x: screenSize.width-62, y: 4, width: 34, height: 34))
        profile.layer.cornerRadius = 17
        profile.clipsToBounds = true
        profile.isUserInteractionEnabled = true
        profile.backgroundColor = UIColor.darkGray
        profile.sd_setImage(with: URL(string: AppCache.sharedInstance.user.profile_picture), completed: nil)
        titleView.addSubview(profile)
        
        dot = UIImageView(frame: CGRect(x: screenSize.width-38, y: 2, width: 12, height: 12))
        dot.image = #imageLiteral(resourceName: "unread")
        dot.isHidden = true
        titleView.addSubview(dot)
        updateDot()
        
        self.addSubview(titleView)
    }
    
    @objc func updateDot() {
        if (AppCache.sharedInstance.unreadCount > 0) {
            dot.isHidden = false
            UIApplication.shared.applicationIconBadgeNumber = AppCache.sharedInstance.unreadCount
        } else {
            dot.isHidden = true
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    @objc func updateProfile() {
        nameLabel.text = AppCache.sharedInstance.user.name
        profile.sd_setImage(with: URL(string: AppCache.sharedInstance.user.profile_picture), completed: nil)
    }
    
    override func draw(_ rect: CGRect) {

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class navView: UIView {
    
    var title: String!
    var nameLabel : UILabel!
    var profile : UIImageView!
    var dot: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.setObserver(self, selector: #selector(self.updateDot), name: NSNotification.Name(rawValue: "updateUnreadCount"), object: nil)
        NotificationCenter.default.setObserver(self, selector: #selector(self.updateProfile), name: NSNotification.Name(rawValue: "profileUpdateNotif"), object: nil)
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        titleView.backgroundColor = UIColor.white
        
        nameLabel = UILabel(frame: CGRect(x: 10, y: 4, width: screenSize.width-140, height: 34))
        nameLabel.font = AppFont.ExtraBold.pt28
        nameLabel.textColor = UIColor.black
        nameLabel.text = AppCache.sharedInstance.user.name
        titleView.addSubview(nameLabel)
        
        profile = UIImageView(frame: CGRect(x: screenSize.width-62, y: 4, width: 34, height: 34))
        profile.layer.cornerRadius = 17
        profile.clipsToBounds = true
        profile.isUserInteractionEnabled = true
        profile.backgroundColor = UIColor.darkGray
        profile.sd_setImage(with: URL(string: AppCache.sharedInstance.user.profile_picture), completed: nil)
        titleView.addSubview(profile)
        
        dot = UIImageView(frame: CGRect(x: screenSize.width-38, y: 2, width: 12, height: 12))
        dot.image = #imageLiteral(resourceName: "unread")
        dot.isHidden = true
        titleView.addSubview(dot)
        updateDot()
        
        self.addSubview(titleView)
    }
    
    @objc func updateDot() {
        if (AppCache.sharedInstance.unreadCount > 0) {
            dot.isHidden = false
        } else {
            dot.isHidden = true
        }
    }
    
    @objc func updateProfile() {
        profile.sd_setImage(with: URL(string: AppCache.sharedInstance.user.profile_picture), completed: nil)
    }
    
    override func draw(_ rect: CGRect) {
        nameLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CountView: UIView {
    
    var circularSlider = MSGradientCircularSlider()
    var titleLabel = UILabel()
    var title : String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel.font = AppFont.Regular.pt12
        self.titleLabel.textAlignment = .center
        
        self.circularSlider.backgroundColor = .white
        self.circularSlider.lineWidth = 1
        self.circularSlider.filledColor = UIColor.black
        self.circularSlider._firstGradientColor = UIColor.red
        self.circularSlider._secondGradientColor = UIColor.black
        self.circularSlider._thirdGradientColor = UIColor.black
        self.circularSlider.unfilledColor = UIColor.steel.withAlphaComponent(0.5)
        self.circularSlider.handleColor = UIColor.clear
        self.circularSlider.isUserInteractionEnabled = false
        self.circularSlider.currentValue = 90
    }
    
    override func draw(_ rect: CGRect) {
            
        self.circularSlider.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        self.addSubview(circularSlider)
        
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
