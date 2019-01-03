
import Foundation
import Alamofire
import SwiftyJSON
import Localize_Swift
import AudioToolbox
import UserNotifications
import SwiftyStoreKit
import Fabric
import Haptica

class API {
    
    static let sharedInstance = API()
    
    public typealias onCompleteHandler = ((JSON, NSError?)->())
    
    func get(url: String, params: [String : AnyObject], onComplete: @escaping onCompleteHandler ) {
        let url = baseUrl.absoluteString + url
        let parameters = self.encryptAndReturnParameters(parameters: params )
        print(url,parameters)
        linkfy(url: url, params: parameters)
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success( _):
                let json = JSON(response.result.value!)
                print(url,json)
                onComplete(json, nil)
            case .failure(let error):
                print(url,error)
                //CLSLogv("getJSON Error - url: %@ , params: %@", getVaList([url,parameters]))
                onComplete(.null, error as NSError?)
            }
        }
    }
    
    func post(url: String, params: [String : AnyObject], onComplete:@escaping onCompleteHandler) {
        let url = baseUrl.absoluteString + url
        let parameters = self.encryptAndReturnParameters(parameters: params )
        print(url,parameters)
        linkfy(url: url, params: parameters)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            switch response.result {
            case .success( _):
                let json = JSON(response.result.value!)
                print(url,json)
                onComplete(json, nil)
            case .failure(let error):
                print(url,error)
                onComplete(.null, error as NSError?)
            }
        }
        
    }
    
    func upload(url: String, image: UIImage!, params: [String : AnyObject], onComplete: @escaping onCompleteHandler) {
        
        let url = baseUrl.absoluteString + url
        let parameters = self.encryptAndReturnParameters(parameters: params )
        print(url,parameters)
        
        Alamofire.upload(multipartFormData: {
            (multipartFormData) in
            
            if (image != nil) {
                
                if (image.size.width > 0) {
                    let resizedimage = image?.scaled(toWidth: 200)
                    let imageData = resizedimage?.jpegData(compressionQuality: 0.6)
                    
                    if (imageData != nil) {
                        let imageSize = Double(imageData!.count)
                        print("size of image in KB: %f ", imageSize / 1024.0)
                        multipartFormData.append(imageData!, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpg")
                    }
                    
                }
            }
            
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        },to: url) { (result) in
            switch result {
                
            case .success(let upload, _, _):
                upload.responseJSON {
                    response in
                    let json = JSON(response.result.value!)
                    print(json)
                    onComplete(json, nil)
                }
            case .failure(let error):
                print(error)
                onComplete(.null, error as NSError?)
            }
        }
    }
    
    func uploadImageFiles(url: String, image: UIImage?, params: [String : AnyObject], onComplete: @escaping onCompleteHandler) {
        
        let url = baseUrl.absoluteString + url
        let parameters = self.encryptAndReturnParameters(parameters: params )
        print(url,parameters)
        
        Alamofire.upload(multipartFormData: {
            (multipartFormData) in //UIImageJPEGRepresentation(image!, 0.9)
            
            if (image != nil) {
                
                let resizedimage = image?.scaled(toWidth: 400)
                let imageData = resizedimage?.jpegData(compressionQuality: 0.6)
                
                if (imageData != nil) {
                    let imageSize = Double(imageData!.count)
                    print("size of image in KB: %f ", imageSize / 1024.0)
                    multipartFormData.append(imageData!, withName: "files", fileName: "photo.jpg", mimeType: "image/jpg")
                    
                }
            }
            
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        },to: url) { (result) in
            switch result {
                
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "uploadProgress"), object: nil, userInfo:["type": "image", "progress": Progress.fractionCompleted])
                })
                
                upload.responseJSON {
                    response in
                    let json = JSON(response.result.value!)
                    print(json)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "uploadProgress"), object: nil, userInfo:["type": "image", "progress": 1.0])
                    onComplete(json, nil)
                }
            case .failure(let error):
                print(error)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "uploadProgress"), object: nil, userInfo:["type": "image", "progress": 1.0])
                onComplete(.null, error as NSError?)
            }
        }
    }
    
    func encryptAndReturnParameters(parameters: [String : AnyObject]) -> [String: AnyObject] {
        
        var sortedKeys = parameters.sorted{$0.0 < $1.0}
        var paramString = ""
        
        for (_, value) in sortedKeys {
            paramString.addString(str: String(describing: value))
        }
        
        paramString.addString(str: "***")
        
        let encr = paramString.sha256()
        sortedKeys.append((key: "encr", value: "\(encr)" as AnyObject ))
        
        
        var newParams = [String: AnyObject]()
        //let sortag = sortedKeys.sorted{$0.key < $1.key}
        
        for (key, value) in sortedKeys  {
            newParams[key] = value
        }
        
        return newParams
    }
    
    func linkfy(url:String, params:[String : AnyObject]) {
        
        #if DEBUG
        var linkStr = url + "?"
        
        for (key, value) in params {
            linkStr.append(key + "=" + "\(value)" + "&")
        }
        
        print(linkStr)
        #endif
    }
 
    //apis
    
    func createToken(onComplete: @escaping (_ status: Bool) -> ()) {
        
        let parameters = [
            "language": Localize.currentLanguage(),
            "type":"ios",
            "app_version": APP_VERSION
        ]
        
        self.post(url: "device/register", params: parameters as [String : AnyObject]) { (json, error) in
            if let e = error {
                print(e.localizedDescription)
                onComplete(false)
            } else {
                guard json["status"] == true else {
                    return onComplete(false)
                }
                
                UserDefaults.standard.set("\(json["data"]["token"])", forKey: "token")
                UserDefaults.standard.synchronize()
                
                AppCache.sharedInstance.token = json["data"]["token"].stringValue
                
                onComplete(true)
            }
            
            
        }
    }
    
    func changeLang(lang:String, onComplete: @escaping (_ status: Bool) -> ()) {
        let parameters = [
            "token" : AppCache.sharedInstance.token,
            "auth": AppCache.sharedInstance.auth,
            "lang": lang
        ]
        
        self.post(url: "user/update-lang", params: parameters as [String : AnyObject]) { (json, error) in
            if let e = error {
                print(e.localizedDescription)
                onComplete(false)
            } else {
                guard json["status"] == true else {
                    let mesage = json["messages"].stringValue
                    ShowErrorMessage.statusLine(message: mesage)
                    return onComplete(false)
                }
                
                UserDefaults.standard.set("\(json["data"]["token"])", forKey: "token")
                UserDefaults.standard.synchronize()
                
                AppCache.sharedInstance.token = json["data"]["token"].stringValue
                
                onComplete(true)
            }
            
            
        }
    }
    
    func updatePush() {
        
        #if DEBUG
        let parameters = [
            "token": AppCache.sharedInstance.token,
            "auth": AppCache.sharedInstance.auth,
            "registration_id": AppCache.sharedInstance.registrationID,
            "test_type" : 1,
            "device_os" : ""
            ] as [String : Any]
        #else
        let parameters = [
            "token": AppCache.sharedInstance.token,
            "auth": AppCache.sharedInstance.auth,
            "registration_id": AppCache.sharedInstance.registrationID
            ] as [String : Any]
        #endif
        
        self.post(url: "user/update-push", params: parameters as [String : AnyObject]) { (json, error) in
            if let e = error {
                print(e.localizedDescription)
            } else {
                print(json)
            }
            
        }
    }
    
    func loadNotifications() {
        
        let parameters = [
            "token" : AppCache.sharedInstance.token,
            "auth": AppCache.sharedInstance.auth,
            "last_id" : 0
            ] as [String : Any]
        
        API.sharedInstance.get(url: "user/notifications", params: parameters as [String : AnyObject]) { (json, error) in
            
            if let e = error {
                print(e)
                ShowErrorMessage.statusLine(message: e.localizedDescription)
            } else {
                guard json["status"].boolValue == true else {
                    let mesage = json["messages"].stringValue
                    ShowErrorMessage.statusLine(message: mesage)
                    return
                }
                
                let notif_array = json["data"]["notifications"].arrayValue
                
                var notifData = [Notif]()
                
                for i in 0..<notif_array.count {
                    notifData.append(Notif(json: notif_array[i]))
                }

                let first_id = notifData.first?.id
                let unread_id = UserDefaults.standard.integer(forKey: "notif_unread_id")
                
                if (first_id > unread_id) {
                    AppCache.sharedInstance.unreadNotifCount = 1
                    NotificationCenter.default.post(name: Notification.Name("updateTabbarNotif"), object: nil)
                }
                
            }
        }
    }

    
    func checkSubscription(completion: @escaping (_ result: Bool)->()) {
 
        //TODO: .production
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: ss)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            if case .success(let receipt) = result {
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(ofType: .autoRenewable, productIds: IAPSet, inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("Product is valid until \(expiryDate)")
                    UserDefaults.standard.set(expiryDate, forKey: "appExpire")
                    AppCache.sharedInstance.expireDate = "\(expiryDate)"
                    AppCache.sharedInstance.isPremium = true
                    API.sharedInstance.updatePayment(product: (items.first?.productId)!, status: "active", expired: expiryDate.string(withFormat: "YYYY-MM-dd HH:mm:ss"), transID: (items.first?.transactionId)!)
                    completion(true)
                case .expired(let expiryDate, let items):
                    print("Product is expired since \(expiryDate)")
                    UserDefaults.standard.set(expiryDate, forKey: "appExpire")
                    AppCache.sharedInstance.expireDate = "\(expiryDate)"
                    AppCache.sharedInstance.isPremium = false
                    API.sharedInstance.updatePayment(product: (items.first?.productId)!, status: "expired", expired: expiryDate.string(withFormat: "YYYY-MM-dd HH:mm:ss"), transID: (items.first?.transactionId)!)
                    completion(false)
                case .notPurchased:
                    print("This product has never been purchased")
                    AppCache.sharedInstance.isPremium = false
                    //API.sharedInstance.updatePayment(product: "", status: "expired", expired: Date().string(withFormat: "YYYY-MM-dd HH:mm:ss"), transID: "")
                    completion(false)
                }
            } else {
                print("Receipt verification error", result)
                completion(false)
            }
        }
    }
    
    func restoreReciept() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                AppCache.sharedInstance.isPremium = true
                self.checkSubscription(completion: { (status) in
                    
                })
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
}

extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func base64String() -> String? {
        
        let imageData = self.jpegData(compressionQuality: 0.9)
        let base64String = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        if let str = base64String {
            return String(format: "data:image/jpeg;base64,%@", str)
        }
        else {
            return nil
        }
    }
    
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
}

extension Sequence{
    
    func group<T:Comparable>(by:KeyPath<Element,T>) -> [(key:T,values:[Element])]{
        
        return self.reduce([]){(accumulator, element) in
            
            var accumulator = accumulator
            var result :(key:T,values:[Element]) = accumulator.first(where:{ $0.key == element[keyPath:by]}) ?? (key: element[keyPath:by], values:[])
            result.values.append(element)
            if let index = accumulator.index(where: { $0.key == element[keyPath: by]}){
                accumulator.remove(at: index)
            }
            accumulator.append(result)
            
            return accumulator
        }
    }
    
    func categorise<U : Hashable>(_ key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}
