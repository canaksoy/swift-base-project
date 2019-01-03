
import Foundation
import UIKit
import SwiftRichString
import AudioToolbox
import Localize_Swift

#if !DEBUG
public func debugPrint(items: Any..., separator: String = " ", terminator: String = "\n") {

}
public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {

}
#endif

let baseUrl:URL = URL (string:"https://")!
let chatUrl:URL = URL (string:"https://:8080")!
let APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
let APP_BUILD = Bundle.main.infoDictionary?["CFBundleVersion"] as! String

let screenSize: CGRect = UIScreen.main.bounds
let storyboardMain = UIStoryboard(name: "Main", bundle: nil)

let bannerH = (screenSize.width / 16) * 9

let styleExtraLight10W = Style {
    $0.font = AppFont.ExtraLight.pt10
    $0.color = UIColor.white
}

let styleExtraLight12 = Style {
    $0.font = AppFont.ExtraLight.pt12
}


enum AppFont: String {
    case Light = "Muli-Light"
    case ExtraLight = "Muli-ExtraLight"
    case Bold = "Muli-Bold"
    case ExtraBold = "Muli-ExtraBold"
    case Regular = "Muli"
    case Black = "Muli-Black"
}

extension AppFont {
    
    var pt10: UIFont {
        return UIFont(name: self.rawValue, size: 10.0)!
    }
    
    var pt12: UIFont {
        return UIFont(name: self.rawValue, size: 12.0)!
    }
    
    var pt14: UIFont {
        return UIFont(name: self.rawValue, size: 14.0)!
    }
    
    var pt16: UIFont {
        return UIFont(name: self.rawValue, size: 16.0)!
    }
    
    var pt18: UIFont {
        return UIFont(name: self.rawValue, size: 18.0)!
    }
    
    var pt20: UIFont {
        return UIFont(name: self.rawValue, size: 20.0)!
    }
    
}

extension UIColor {
    
    static let primaryColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
    
    @nonobjc class var pinkred: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 1.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var strongPink: UIColor {
        return UIColor(red: 1.0, green: 2.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var marigold: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 203.0 / 255.0, blue: 1.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var steel: UIColor {
        return UIColor(red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var greeny: UIColor {
        return UIColor(red: 96.0 / 255.0, green: 203.0 / 255.0, blue: 67.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var grayLight: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 251.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var veryLight: UIColor {
        return UIColor(white: 238.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var facebook: UIColor {
        return UIColor(red: 37.0/255.0, green: 71.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    }
    
    @nonobjc class var error: UIColor {
        return UIColor(red: 197.0 / 255.0, green: 95.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0)
    }
    
}

extension UIButton{
    
    func addTextSpacing(_ letterSpacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
}

extension UILabel{
    
    func addTextSpacing(_ letterSpacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: (self.text!))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: self.text!.count))
        self.attributedText = attributedString
    }
    
    func set(image: UIImage, with text: String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        let attachmentStr = NSAttributedString(attachment: attachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        
        let textString = NSAttributedString(string: text, attributes: [.font: self.font])
        mutableAttributedString.append(textString)
        
        self.attributedText = mutableAttributedString
    }
    
}

extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
    
    mutating func addString(str: String) {
        self = self + str
    }
    
    public var isEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                     options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func timezonedDate() -> Date {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: self) ?? Date()
    }
    
    var html2AttributedString: NSAttributedString? {
        
        let modifiedString = "<style>body{font-family: 'Muli-ExtraLight'; font-size:12px; color:#000000; }</style>\(self)"
        guard
            let data = modifiedString.data(using: String.Encoding.utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func attributedPoint(label: UILabel) -> NSAttributedString {
        
        var attText = NSAttributedString()
        
        let styleValue = Style {
            $0.font = label.font
            $0.color = label.textColor
        }
        
        let styleP = Style {
            $0.font = UIFont(name: AppFont.ExtraLight.rawValue, size: label.font.pointSize)!
            $0.color = label.textColor
        }
        
        attText = (label.text?.set(style: styleValue))! + ("p".localized().set(style: styleP))
        
        return attText
    }
    
}

extension Int{
    func stringValue() -> String {
        return String(self)
    }
    var CGFloatValue: CGFloat { return CGFloat(self) }
    var floatValue: Float { return Float(self) }
    
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)"+"Milyon".localized()
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)"+"Bin".localized()
        }
        else {
            return "\(Int(number))"
        }
    }
}

extension NotificationCenter {
    func setObserver(_ observer: AnyObject, selector: Selector, name: NSNotification.Name, object: AnyObject?) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImage {
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
    
    func blurr(radius: CGFloat) -> UIImage {
        let ciContext = CIContext(options: nil)
        guard let cgImage = cgImage else { return self }
        let inputImage = CIImage(cgImage: cgImage)
        guard let ciFilter = CIFilter(name: "CIGaussianBlur") else { return self }
        ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        ciFilter.setValue(radius, forKey: "inputRadius")
        guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
        return UIImage(cgImage: cgImage2)
    }
    
}

extension NSLocale
{
    class func localeForCountry(countryName : String) -> String?
    {
        return NSLocale.isoCountryCodes.first{self.countryNameFromLocaleCode(localeCode: $0 ) == countryName}
    }
    
    class func countryNameFromLocaleCode(localeCode : String) -> String
    {
        return NSLocale(localeIdentifier: "tr_TR").displayName(forKey: NSLocale.Key.countryCode, value: localeCode) ?? "-"
    }
}

extension UIApplication {
    /// Run a block in background after app resigns activity
    public func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }
    
}

extension SystemSoundID {
    static func playFileNamed(fileName: String, withExtenstion fileExtension: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
}

extension UIViewController {
    
    func updateTitleView(title: String, subtitle: String?, baseColor: UIColor = .black) {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = baseColor
        titleLabel.font = AppFont.ExtraBold.pt16
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.textColor = baseColor.withAlphaComponent(0.95)
        subtitleLabel.font = AppFont.ExtraLight.pt12
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        if subtitle != nil {
            titleView.addSubview(subtitleLabel)
        } else {
            titleLabel.frame = titleView.frame
        }
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        navigationItem.titleView = titleView
    }
    
}

extension UINavigationController {
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}

extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }
        
        let lastSection = numberOfSections - 1
        
        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }
        
        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .right, animated: true)
    }
}

extension Date {
    
    func timeAgo() -> String {
        
        let calendar = Calendar.current
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: Date(), options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year)" + " sene önce".localized()
        }
        
        if let year = components.year, year >= 1 {
            return "Geçen sene".localized()
        }
        
        if let month = components.month, month >= 2 {
            return "\(month)" + " ay önce".localized()
        }
        
        if let month = components.month, month >= 1 {
            return "Geçen ay".localized()
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week)" + " hafta önce".localized()
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Geçen hafta".localized()
        }
        
        if let day = components.day, day >= 2 {
            return "\(day)" + " gün önce".localized()
        }
        
        if let day = components.day, day >= 1 {
            return "Dün".localized() + " " + self.timeString(ofStyle: .short)
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour)" + " saat önce".localized()
        }
        
        if let hour = components.hour, hour >= 1 {
            return "1 saat önce".localized()
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute)" + " dakika önce".localized()
        }
        
        if let minute = components.minute, minute >= 1 {
            return "1 dakika önce".localized()
        }
        
        if let second = components.second, second >= 3 {
            return "\(second)" + " saniye önce".localized()
        }
        
        return "Şimdi".localized()
        
    }
    
}
extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}

class ChainedAnimationsQueue {
    
    private var playing = false
    private var animations = [(TimeInterval, () -> Void, () -> Void)]()
    
    init() {
    }
    
    /// Queue the animated changes to one or more views using the specified duration and an initialization block.
    ///
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    ///   - initializations: A block object containing the changes to commit to the views to set their initial state. This block takes no parameters and has no return value. This parameter must not be NULL.
    ///   - animations: A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value. This parameter must not be NULL.
    func queue(withDuration duration: TimeInterval, initializations: @escaping () -> Void, animations: @escaping () -> Void) {
        self.animations.append((duration, initializations, animations))
        if !playing {
            playing = true
            DispatchQueue.main.async {
                self.next()
            }
        }
    }
    
    private func next() {
        if animations.count > 0 {
            let animation = animations.removeFirst()
            animation.1()
            UIView.animate(withDuration: animation.0, animations: animation.2, completion: { finished in
                self.next()
            })
        } else {
            playing = false
        }
    }
}
