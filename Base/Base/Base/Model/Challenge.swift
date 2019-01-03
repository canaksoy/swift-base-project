
import Foundation
import SwiftyJSON
import SwifterSwift

public enum ChallengeStatus: String {
    case active = "active"
    case wait = "wait"
    case cancel = "cancel"
    case reject = "reject"
    case end = "end"
    case deleted = "deleted"
    case maybe = "maybe"
    case retreated = "retreated"
    case timeout = "timeOut"
    
    func title() -> String{
        
        switch self {
        case .active:
            return "Aktif".localized()
        case .wait:
            return "Beklemede".localized()
        case .reject:
            return "Reddedildi".localized()
        case .cancel:
            return "İptal Edildi".localized()
        case .end:
            return "Tamamlandı".localized()
        case .deleted:
            return "Silindi".localized()
        case .maybe:
            return "Belki".localized()
        case .retreated:
            return "Geri Çekildi".localized()
        case .timeout:
            return "Süre Doldu".localized()
        }
        
    }
}

public enum ChallengeUserStatus: String {
    case wait = "wait"
    case end = "end"
    case start = "start"
    case maybe = "maybe"
    case pass = "pass"
    case retreated = "retreated"
    case reject = "reject"
    case timeout = "timeOut"
    
    func title() -> String{
        
        switch self {
        case .wait:
            return "Cevap Bekleniyor".localized()
        case .pass:
            return "Kabul Etti".localized()
        case .reject:
            return "Kabul Etmedi".localized()
        case .start:
            return "Koşmaya Başladı".localized()
        case .end:
            return "Koştu".localized()
        case .maybe:
            return "Belki".localized()
        case .retreated:
            return "İptal Edildi".localized()
        case .timeout:
            return "Süre Doldu".localized()
        }
        
    }
}

class ChallengeUser {
    
    var id: Int!
    var status: ChallengeUserStatus!
    var user: User!
    var user_locations: [UserLocation]!
    var started_at: Date!
    var finished_at: Date!
    var winner: Bool!
    
    static let sharedInstance = ChallengeUser()
    
    init() {
        
    }
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.status = ChallengeUserStatus(rawValue: String(json["status"].stringValue))
        self.user = User(setWithRegisterData: json["user"])
        self.started_at = json["started_at"].stringValue.timezonedDate()
        self.finished_at = json["finished_at"].stringValue.timezonedDate()
        self.winner = json["winner"].boolValue
        
        user_locations = []
        let loc_array = json["user_locations"].arrayValue
        for i in 0..<loc_array.count {
            user_locations.append(UserLocation(json: loc_array[i]))
        }
    }
}

class Challenge {
    
    var id: Int!
    var user_id: Int!
    var timer: Int!
    var km: Int!
    var multiplication: Int!
    var status: ChallengeStatus!
    var created_at: Date!
    var started_at: Date!
    var finished_at: Date!
    var maybe_at: Date!
    var updated_at: Date!
    var likes: Int!
    var user_like_count: Int!
    var challengeUsers: [ChallengeUser]!
    
    static let sharedInstance = Challenge()
    
    init() {
        
    }
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.user_id = json["user_id"].intValue
        self.timer = json["timer"].intValue
        self.km = json["km"].intValue
        self.multiplication = json["multiplication"].intValue
        self.status = ChallengeStatus(rawValue: String(json["status"].stringValue))
        self.created_at = json["created_at"].stringValue.timezonedDate()
        self.started_at = json["started_at"].stringValue.timezonedDate()
        self.maybe_at = json["maybe_at"].stringValue.timezonedDate()
        self.finished_at = json["finished_at"].stringValue.timezonedDate()
        self.updated_at = json["updated_at"].stringValue.timezonedDate()
        self.likes = json["likes"].intValue
        self.user_like_count = json["user_like_count"].intValue
        
        challengeUsers = []
        let users_array = json["users"].arrayValue
        for i in 0..<users_array.count {
            challengeUsers.append(ChallengeUser(json: users_array[i]))
        }
        
    }
    
}

class UserLocation {
    
    var id: Int!
    var user_id: Int!
    var challenge_id: Int!
    var lat: Double!
    var lon: Double!
    var speed: Double!
    var accuracy: Double!
    var altitude: Double!
    var request_time: Date!
    
    static let sharedInstance = UserLocation()
    
    init() {
        
    }
    
    init(json: JSON) {
        
        self.id = json["id"].intValue
        self.user_id = json["user_id"].intValue
        self.challenge_id = json["challenge_id"].intValue
        self.lat = json["lat"].doubleValue
        self.lon = json["lon"].doubleValue
        self.speed = json["speed"].doubleValue
        self.accuracy = json["accuracy"].doubleValue
        self.altitude = json["altitude"].doubleValue
        
    }
}

class LikeUser {
    
    var id: Int!
    var point: Int!
    var user: User!
    
    static let sharedInstance = LikeUser()
    
    init() {
        
    }
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.point = json["point"].intValue
        self.user = User(setWithRegisterData: json["user"])
    }
}
