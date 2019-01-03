
import Foundation
import CoreLocation

class AppCache {
    
    static let sharedInstance = AppCache()
    
    var token = ""
    var auth = ""
    var chat = ""
    var accessToken = ""
    var registrationID = ""
    var user = User()
    var isPremium = false
    var expireDate = ""
    
    var userLocation = CLLocation()
    var userSpeed = 0
    var userAltitude = 0
    var userAccuracy = 0
    var userChallenge = Challenge()
    
    var unreadCount = 0
    var unreadNotifCount = 0
    var activeConvID = ""

}
