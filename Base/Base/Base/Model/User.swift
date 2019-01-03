
import UIKit
import SwiftyJSON

public enum UserPlace: String {
    case city = "city"
    case park = "park"
    case mountain = "mountain"
}

class User{
    
    
    var id: Int!
    var username: String!
    var name: String!
    var surname: String!
    var fullname: String!
    var email: String!


    
    private (set) var password: String?
    
    static let sharedInstance = User()
    
    init() {
        
    }
    
    init(setWithRegisterData json: JSON) {
        
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue
        self.surname  = json["last_name"].stringValue
        self.fullname  = name + " " + surname
        self.username = json["username"].stringValue
        self.email = json["email"].stringValue

        
        let ch_array = json["challenges"].arrayValue
        for i in 0..<ch_array.count {
            let ch = Challenge(json: ch_array[i])
            challenges.append(ch)
        }

    }

}

class UserPhoto {
    
    var id: Int!
    var image: String!
    var thumb_image: String!
    var likes: Int!
    var is_like: Bool!
    
    static let sharedInstance = UserPhoto()
    
    init() {
        
    }
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.image = json["image"].stringValue
        self.thumb_image = json["thumb_image"].stringValue
        self.likes = json["likes"].intValue
        self.is_like = json["is_like"].boolValue
        
    }
}

class UserEvent {
    
    var id: Int!
    var event_id: Int!
    var point: Int!
    var max_point: Int!
    var rank: Int!
    
    var event: Event!
    
    static let sharedInstance = UserPhoto()
    
    init() {
        
    }
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.event_id = json["event_id"].intValue
//        self.point = json["point"].intValue
//        self.max_point = json["max_point"].intValue
//        self.rank = json["rank"].intValue
        self.event = Event(json: json["event"] )
        
        self.max_point = self.event.max_limit
        self.point = self.event.user_point
        self.rank = self.event.user_rank
        
    }
}
