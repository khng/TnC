import Quick
import Nimble

@testable import Test_Project

class RatingControlSpec: QuickSpec {
    override func spec() {
        var subject: RatingControl!
        
        beforeEach {
            subject = RatingControl(frame: CGRect())
        }
        context("when rating is intialized") {
            beforeEach {
                subject.setRating(rating: 0)
            }
            it("should show a rating of 0") {
                expect(subject.rating).to(equal(0))
            }
            it("should display 5 stars") {
                for i in 0..<5 {
                    expect(subject.stars[i].isHidden).to(beFalse())
                }
            }
            context("when rating is received") {
                it("should displayed a rating of 0") {
                    for i in 0..<5 {
                        expect(subject.stars[i].currentImage).to(equal(UIImage(named: "emptyStar")))
                    }
                }
                it("should displayed a rating of 3.5") {
                    subject.setRating(rating: 3.5)
                    expect(subject.stars[0].currentImage).to(equal(UIImage(named: "filledStar")))
                    expect(subject.stars[1].currentImage).to(equal(UIImage(named: "filledStar")))
                    expect(subject.stars[2].currentImage).to(equal(UIImage(named: "filledStar")))
                    expect(subject.stars[3].currentImage).to(equal(UIImage(named: "halfFilledStar")))
                    expect(subject.stars[4].currentImage).to(equal(UIImage(named: "emptyStar")))
                }
                it("should displayed a rating of 5") {
                    subject.setRating(rating: 5)
                    for i in 0..<5 {
                        expect(subject.stars[i].currentImage).to(equal(UIImage(named: "filledStar")))
                    }
                }
            }
        }
    }
}
