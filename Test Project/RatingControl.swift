import UIKit

protocol RatingProtocol {
    var rating: Double { get set }
    
    var stars: [UIButton] { get set }
}

class RatingControl: UIStackView, RatingProtocol {
    var stars: [UIButton] = []
    
    var rating: Double = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)        
    }
    
    func initializeStars() {
        for button in stars {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        stars.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let halfFilledStar = UIImage(named: "halfFilledStar", in: bundle, compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        
        var i = 1.0
        while(i <= 5) {
            let button = UIButton()
            
            if i <= rating {
                button.setImage(filledStar, for: .normal)
            } else if i > rating && i < rating + 1 {
                button.setImage(halfFilledStar, for: .normal)
            } else {
                button.setImage(emptyStar, for: .normal)
            }
            
            button.isUserInteractionEnabled = false
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 54.8).isActive = true
            button.widthAnchor.constraint(equalToConstant: 54.8).isActive = true
            
            addArrangedSubview(button)
            stars.append(button)
            i += 1
        }
    }
    
    func setRating(rating: Double) {
        self.rating = rating
        initializeStars()
    }
}
