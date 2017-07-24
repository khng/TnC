import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var stars: RatingControl!
    var searchProvider: YelpSearchProvider
    var locationManager: LocationManagerWrapper
    var mostRecentSearchResult: Result
    
    init(searchProvider: YelpSearchProvider, locationManager: LocationManagerWrapper) {
        self.searchProvider = searchProvider
        self.locationManager = locationManager
        mostRecentSearchResult = Result()
        super.init(nibName: String(describing: MainViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchProvider.authorize()
    }
    
    @IBAction func selectSearchButton(_ sender: Any) {
        searchProvider.search( completionHandler: { (result) in
            DispatchQueue.main.async {
                if (result.name != "") {
                    self.mostRecentSearchResult.name = result.name
                    self.mostRecentSearchResult.lat = result.lat!
                    self.mostRecentSearchResult.long = result.long!
                    self.errorLabel.isHidden = true
                    self.directionsButton.isHidden = false
                    self.nameLabel.text = result.name
                    self.stars.setRating(rating: result.rating)
                } else {
                    self.errorLabel.isHidden = false
                    self.directionsButton.isHidden = true
                }
            }
        })
    }
    
    @IBAction func selectDirectionsButton(_ sender: Any) {
        locationManager.getDirections(name: mostRecentSearchResult.name, lat: mostRecentSearchResult.lat, long: mostRecentSearchResult.long)
    }
}
