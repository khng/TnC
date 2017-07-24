import CoreLocation
import MapKit

protocol LocationManagerWrapper {
    func getLocation() -> CLLocation
    
    func getLocationStatus() -> Bool
    
    func getDirections(name: String?, lat: Double?, long: Double?)
}

class LocationManagerImpl: NSObject, LocationManagerWrapper, CLLocationManagerDelegate {
    let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
    }
    
    func getLocation() -> CLLocation {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if(getLocationStatus()) {
            locationManager.startUpdatingLocation()
            
            return locationManager.location!
        }
        return CLLocation(latitude: 0,longitude: 0)
    }
    
    func getLocationStatus() -> Bool {
        return CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways
    }
    
    func getDirections(name: String?, lat: Double?, long: Double?) {
        let destinationCoordinates = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinates))
        destination.name = name!
        destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
}
