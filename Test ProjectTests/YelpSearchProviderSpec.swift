import Quick
import Nimble
import CoreLocation
import YelpAPI

@testable import Test_Project

class YelpSearchProviderSpec: QuickSpec {
    
    override func spec() {
        var subject: YelpSearchProviderWrapper!
        var ylpClientWrapper: YLPClientWrapper!
        var ylpClientMock: YLPClientMock!
        var locationManagerWrapper: LocationManagerMock!
        
        beforeEach {
            ylpClientMock = YLPClientMock()
            ylpClientWrapper = YLPClientMock(identifier: "Test") as YLPClientWrapper
            locationManagerWrapper = LocationManagerMock()
                
            subject = YelpSearchProviderWrapper(clientGenerator: ylpClientMock, locationManager: locationManagerWrapper)
        }
        
        context("when authorization fails") {
            beforeEach {
                subject.authorize()
                
                ylpClientMock.completionHandlerCapture(nil, NSError.init(domain: "temp", code: 123, userInfo: nil))
            }
            it("should handle failed auth") {
                expect(subject.log).toEventually(equal("Authorization failed"))
            }
        }
        
        context("when authorization succeeds") {
            beforeEach {
                subject.authorize()
                
                ylpClientMock.completionHandlerCapture(ylpClientWrapper, nil)
            }
            it("authorize success") {
                expect(subject.client.compareWith(wrapper: ylpClientWrapper)).to(beTrue())
            }
        }
        
        context("when query fails") {
            var resultName: String!
            beforeEach {
                subject.authorize()
                ylpClientMock.completionHandlerCapture(ylpClientWrapper, nil)
                subject.search(completionHandler: {(result) in
                    resultName = result.name
                })
            }
            it("returns empty result") {
                expect(resultName).to(equal(""))
            }
        }
        
        context("when location services are disabled") {
            beforeEach {
                locationManagerWrapper.hasLocation = false
            }
            it("location should be 0,0") {
                expect(subject.locationManager.getLocation().coordinate.latitude).to(equal(0))
                expect(subject.locationManager.getLocation().coordinate.longitude).to(equal(0))
            }
            context("should search for query location") {
                var resultName: String!
                var lat: Double!
                var long: Double!
                var resultRating: Double!
                beforeEach {
                    subject.authorize()
                    ylpClientMock.completionHandlerCapture(ylpClientWrapper, nil)
                    subject.search(completionHandler: {(result) in
                        resultName = result.name
                        lat = result.lat
                        long = result.long
                        resultRating = result.rating
                    })
                }
                it("should match long and lat received by wrapper") {
                    expect(ylpClientMock.lat).to(equal(0))
                    expect(ylpClientMock.long).to(equal(0))
                }
                it("should return empty result") {
                    expect(resultName).to(equal(""))
                }
                it("should return 0,0 for result coordinate") {
                    expect(lat).to(equal(0))
                    expect(long).to(equal(0))
                }
                it("should return 0 for result rating") {
                    expect(resultRating).to(equal(0))
                }
            }
        }
        
        context("when location services are enabled") {
            beforeEach {
                locationManagerWrapper.hasLocation = true
            }
            it("location should be 43.6532, 79.3832") {
                expect(subject.locationManager.getLocation().coordinate.latitude).to(equal(43.6532))
                expect(subject.locationManager.getLocation().coordinate.longitude).to(equal(-79.3832))
            }
            context("should search for query location") {
                var resultName: String!
                var lat: Double!
                var long: Double!
                var resultRating: Double!
                beforeEach {
                    subject.authorize()
                    ylpClientMock.completionHandlerCapture(ylpClientWrapper, nil)
                    subject.search(completionHandler: {(result) in
                        resultName = result.name
                        lat = result.lat
                        long = result.long
                        resultRating = result.rating
                    })
                }
                it("should match long and lat received by wrapper") {
                    expect(ylpClientMock.lat).to(equal(43.6532))
                    expect(ylpClientMock.long).to(equal(-79.3832))
                }
                it("should return result name") {
                    expect(resultName).to(equal("Coordinates match"))
                }
                it("should return coordinates of result") {
                    expect(lat).to(equal(43.6532))
                    expect(long).to(equal(-79.3832))
                }
                it("should return the rating of result") {
                    expect(resultRating).to(equal(3.5))
                }
            }
        }
    }
}

class YLPClientMock: YLPClientWrapper {   
    typealias CompletionHandler = (YLPClientWrapper?, Error?) ->  ()
    var completionHandlerCapture: CompletionHandler!
    var identifier: String
    var lat: Double!
    var long: Double!
    var searchResult: String!
    
    init() {
        identifier = ""
    }
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
    func authorize(withAppId appId: String, secret: String, completionHandler: @escaping (YLPClientWrapper?, Error?) -> Void) {
        completionHandlerCapture = completionHandler
    }
    
    func compareWith(wrapper: YLPClientWrapper) -> Bool {
        return (wrapper as! YLPClientMock).identifier == self.identifier
    }
    
    func search(lat: Double, long: Double, completionHandler: @escaping (Result) -> Void) {
        self.lat = lat
        self.long = long
        if(lat == 43.6532 && long == -79.3832) {
            completionHandler(Result(name: "Coordinates match", lat: lat, long: long, rating: 3.5, address: ""))
        } else {
            completionHandler(Result())
        }
    }
}

class LocationManagerMock: LocationManagerWrapper {
    var hasLocation: Bool
    
    init() {
        hasLocation = false
    }
    
    func getLocation() -> CLLocation {
        if(getLocationStatus()) {
            return CLLocation(latitude: 43.6532, longitude: -79.3832)
        }
        return CLLocation(latitude: 0, longitude: 0)
    }
    
    func getLocationStatus() -> Bool {
        return hasLocation
    }
    
    func getDirections(name: String?, lat: Double?, long: Double?) {
        
    }
    
}
