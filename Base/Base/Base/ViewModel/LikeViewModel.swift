
import Foundation
import SwiftyJSON

enum LikeStatus {
    case like
    case unlike
    case none
}

class LikeViewModel {
    
    public typealias onCompleteHandler = ((Bool, String?, LikeStatus)->())

    open class func loremTapped(meal: Meal!, onComplete: @escaping onCompleteHandler) {
        
        let params = [
            "token": AppCache.sharedInstance.token,
            "auth": AppCache.sharedInstance.auth,
            "id": lorem.id!
            ] as [String : Any]
        
        API.sharedInstance.post(url: "likes/like", params: params as [String : AnyObject]) { (json, error) in
            if let e = error {
                onComplete(false, "\(e)", LikeStatus.none)
            } else {
                guard json["status"].boolValue == true else {
                    return onComplete(false, json["messages"].stringValue, LikeStatus.none)
                }
                
                if json["data"]["status"] == "liked" {
                    onComplete(true, nil, LikeStatus.like)
                } else {
                    onComplete(true, nil, LikeStatus.unlike)
                }
                
            }
        }
    }
}
