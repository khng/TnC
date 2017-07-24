import Quick
import Nimble
import CoreLocation

@testable import Test_Project

class MainViewControllerSpec: QuickSpec {
    
    override func spec() {
        var subject: MainViewController!
        var wrapper: YelpSearchProviderMock!
        var locationManagerWrapper: MainViewControllerLocationManagerMock!
        
        beforeEach {
            wrapper = YelpSearchProviderMock()
            locationManagerWrapper = MainViewControllerLocationManagerMock()
            subject = MainViewController(searchProvider: wrapper, locationManager: locationManagerWrapper)
            expect(subject.view).toNot(beNil())
        }
        
        context("when app loads") {
            it("should display a search button") {
                expect(subject.searchButton).toNot(beNil())
            }
            
            context("before search button is selected") {
                it("authorize on load") {
                    expect((subject.searchProvider as! YelpSearchProviderMock).isAuthorized).toEventually(beTrue())
                }
            }
            context("when no result is returned") {
                beforeEach {
                    wrapper.returnSearchResult = false
                    subject.searchButton.sendActions(for: .touchUpInside)
                }
                it("should give an error") {
                    expect(subject.errorLabel.isHidden).toEventually(beFalse())
                }
                it("should disable directions button") {
                    expect(subject.directionsButton.isHidden).toEventually(beTrue())
                }
            }
            context("when result is returned") {
                beforeEach {
                    wrapper.returnSearchResult = true
                    subject.searchButton.sendActions(for: .touchUpInside)
                }
                it("should display the name of the result") {
                    expect(subject.errorLabel.isHidden).to(beTrue())
                    expect(subject.nameLabel.text).toEventually(equal("There are results"))
                }
                it("should display the directions button") {
                    expect(subject.directionsButton.isHidden).toEventually(beFalse())
                }
                it("should display rating") {
                    expect(subject.stars.rating).toEventually(equal(3.5))
                }
                context("when directions button is pushed") {
                    beforeEach {
                        expect(subject.directionsButton.isHidden).toEventually(beFalse())
                        subject.directionsButton.sendActions(for: .touchUpInside)
                    }
                    it("should open maps") {
                        expect((subject.locationManager as! MainViewControllerLocationManagerMock).mapsOpened).to(beTrue())
                    }
                    it("map manager should receive business info sent by Yelp search provider") {
                        expect((subject.locationManager as! MainViewControllerLocationManagerMock).name).to(equal("There are results"))
                        expect((subject.locationManager as! MainViewControllerLocationManagerMock).lat).to(equal(43.6532))
                        expect((subject.locationManager as! MainViewControllerLocationManagerMock).long).to(equal(-79.3832))
                    }
                }
            }
        }
    }
}

class YelpSearchProviderMock: YelpSearchProvider {
    var isAuthorized: Bool
    var returnSearchResult: Bool
    var searchResult: String!
    
    init() {
        isAuthorized = false
        returnSearchResult = false
    }
    
    func authorize() {
        isAuthorized = true
    }
    
    func search(completionHandler: @escaping (Result) -> Void) {
        if(returnSearchResult) {
            completionHandler(Result(name: "There are results", lat: 43.6532, long: -79.3832, rating: 3.5, address: ""))
        } else {
            completionHandler(Result())
        }
    }
}

class MainViewControllerLocationManagerMock: LocationManagerWrapper {
    var mapsOpened: Bool!
    var name: String!
    var lat: Double!
    var long: Double!
    
    init() {
    }
    
    func getLocation() -> CLLocation {
        if(getLocationStatus()) {
            return CLLocation(latitude: 43.6532, longitude: -79.3832)
        }
        return CLLocation(latitude: 0, longitude: 0)
    }
    
    func getLocationStatus() -> Bool {
        return true
    }
    
    func getDirections(name: String?, lat: Double?, long: Double?) {
        self.name = name
        self.lat = lat
        self.long = long
        mapsOpened = true
    }
    
}
