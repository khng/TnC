import YelpAPI

protocol YLPClientWrapper {
    var identifier: String {get}
    
    func authorize(withAppId appId: String, secret: String, completionHandler: @escaping (YLPClientWrapper?, Error?) -> Swift.Void)
    
    func search(lat: Double, long: Double, completionHandler: @escaping (Result) -> Void)
    
    func compareWith(wrapper: YLPClientWrapper) -> Bool
}

class YLPClientWrapperImpl: YLPClientWrapper {
    var identifier: String
    private var activeClient: YLPClient?
    
    init() {
        identifier = ""
    }
    
    func authorize(withAppId appId: String, secret: String, completionHandler: @escaping (YLPClientWrapper?, Error?) -> Void) {
        YLPClient.authorize(withAppId: appId, secret: secret) { (client, error) in
            if client != nil {
                completionHandler(client as? YLPClientWrapper, error)
                self.activeClient = client
            } else {
                completionHandler(nil, NSError.init())
            }
        }
    }
    
    func search(lat: Double, long: Double, completionHandler: @escaping (Result) -> Void) {
        let currentCoordinates = YLPCoordinate.init(latitude: lat, longitude: long)
        
        let query = YLPQuery(coordinate: currentCoordinates)
        query.term = "Coffee & Tea"
        query.limit = 0
        query.radiusFilter = 500
        
        if (self.activeClient != nil) {
            self.activeClient?.search(with: query, completionHandler: { (result, error) in
                if (error == nil) {
                    if (result!.businesses.count > 0) {
                        var returnResult = Result()
                        let index = Int(arc4random_uniform(UInt32((result?.businesses.count)! - 1)))
                        let searchResult = (result?.businesses[index])!
                        returnResult.name = searchResult.name
                        returnResult.rating = searchResult.rating
                        if let address = searchResult.location.address.first {
                            returnResult.address = address
                        }
                        if let coordinate = searchResult.location.coordinate {
                            returnResult.lat = (coordinate.latitude)
                            returnResult.long = (coordinate.longitude)
                        }
                        completionHandler(returnResult)
                    }
                }
            })
        }
    }
    
    func compareWith(wrapper: YLPClientWrapper) -> Bool {
        return String(describing: wrapper) == String(describing: self)
    }
}
