
import Foundation
import SwiftyJSON

enum Favorite {
    case add
    case delete
    case none
}

class FavoriteViewModel {
    
    public typealias onCompleteHandler = ((Bool, Favorite)->())
    
    open class func setFavorite(user: User!, onComplete: @escaping onCompleteHandler) {
        let params = [
            "token": AppCache.sharedInstance.token,
            "auth": AppCache.sharedInstance.auth,
            "id": user.id!
            ] as [String : Any]
        
        API.sharedInstance.post(url: "favorites/fav", params: params as [String : AnyObject]) { (json, error) in
            if let e = error {
                onComplete(false, Favorite.none)
            } else {
                guard json["status"].boolValue == true else {
                    return onComplete(false, Favorite.none)
                }

                if json["data"]["status"] == "faved" {
                    onComplete(true, Favorite.add)
                } else {
                    onComplete(true, Favorite.delete)
                }
                
            }
        }
    }
    
    

}
