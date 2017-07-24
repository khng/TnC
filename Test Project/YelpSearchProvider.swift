import YelpAPI
import CoreLocation

protocol YelpSearchProvider {
    func authorize()
    
    func search(completionHandler: @escaping (Result) -> Void)
}

class YelpSearchProviderWrapper: YelpSearchProvider {
    var log: String
    var appId: String
    var appSecret: String
    var clientGenerator: YLPClientWrapper!
    var client: YLPClientWrapper!
    var locationManager: LocationManagerWrapper!
    
    init(clientGenerator: YLPClientWrapper, locationManager: LocationManagerWrapper) {
        log = ""
        appId = "lHDyCLi3lh6bhOB6KixgEw"
        appSecret = "tCZyOSdFXoaiHfkHJ9gYAcEeUl8bFncIQe5tmYyh9UefF3DjvMKftZ1IaDALUj5c"
        self.clientGenerator = clientGenerator
        
        self.locationManager = locationManager
    }
    
    func authorize() {
        clientGenerator.authorize(withAppId: appId, secret: appSecret) { (client, error) in
            if error != nil {
                self.log = "Authorization failed"
                return
            }
            self.client = client
        }
    }
    
    func search(completionHandler: @escaping (Result) -> Void) {
        let currentLocation = locationManager.getLocation()
        clientGenerator.search(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude, completionHandler: completionHandler)
    }
}
