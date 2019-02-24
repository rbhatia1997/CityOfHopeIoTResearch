//
//  MoodRating.swift
//  COHPatientUI
//
//  Created by Darien Joso on 2/21/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

//IBDesignable makes it appear in the storyboard
@IBDesignable class MoodRating: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()

    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var buttonSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var buttonCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }

    //MARK: Initialization

    // Make a rectangle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }

    // Archiving and distribution
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    //MARK: Button Action

    @objc func moodButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }

    //MARK: Private Methods

    private func setupButtons() {
        
        // remove buttons otherwise we keep adding buttons to ratingButtons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        
        var normalEmoji: [UIImage] = [UIImage(named: "1-saddest-normal", in: bundle, compatibleWith: self.traitCollection)!,
                                      UIImage(named: "2-sad-normal", in: bundle, compatibleWith: self.traitCollection)!,
                                      UIImage(named: "3-neutral-normal", in: bundle, compatibleWith: self.traitCollection)!,
                                      UIImage(named: "4-happy-normal", in: bundle, compatibleWith: self.traitCollection)!,
                                      UIImage(named: "5-happiest-normal", in: bundle, compatibleWith: self.traitCollection)!]
        
        var selectEmoji: [UIImage] = [UIImage(named: "1-saddest-selected", in: bundle, compatibleWith: self.traitCollection)!,
                                      UIImage(named: "2-sad-selected", in: bundle, compatibleWith: self.traitCollection)!,
                                      UIImage(named: "3-neutral-selected", in: bundle, compatibleWith: self.traitCollection)!,
                                      UIImage(named: "4-happy-selected", in: bundle, compatibleWith: self.traitCollection)!,
                                      UIImage(named: "5-happiest-selected", in: bundle, compatibleWith: self.traitCollection)!]
        
        var highlightEmoji: [UIImage] = [UIImage(named: "1-saddest-selected", in: bundle, compatibleWith: self.traitCollection)!,
                                         UIImage(named: "2-sad-selected", in: bundle, compatibleWith: self.traitCollection)!,
                                         UIImage(named: "3-neutral-selected", in: bundle, compatibleWith: self.traitCollection)!,
                                         UIImage(named: "4-happy-selected", in: bundle, compatibleWith: self.traitCollection)!,
                                         UIImage(named: "5-happiest-selected", in: bundle, compatibleWith: self.traitCollection)!]
        
//        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
//        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
//        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)

        for index in 0..<buttonCount {

            // Create buttons
            let button = UIButton()
            
            if (buttonCount > 5) {
                normalEmoji.append(UIImage(named: "5-happiest-normal", in: bundle, compatibleWith: self.traitCollection)!)
                selectEmoji.append(UIImage(named: "5-happiest-selected", in: bundle, compatibleWith: self.traitCollection)!)
                highlightEmoji.append(UIImage(named: "5-happiest-selected", in: bundle, compatibleWith: self.traitCollection)!)
            }
            
            // Set the button images
            button.setImage(normalEmoji[index], for: .normal)
            button.setImage(selectEmoji[index], for: .selected)
            button.setImage(highlightEmoji[index], for: .highlighted)
            button.setImage(highlightEmoji[index], for: [.highlighted, .selected])

            // Add constraints
            // delete the button's original constraints, use this when using auto layout
            button.translatesAutoresizingMaskIntoConstraints = false

            // set the height and width to 44
            button.heightAnchor.constraint(equalToConstant: buttonSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: buttonSize.width).isActive = true

            // Set accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            button.addTarget(self, action: #selector(MoodRating.moodButtonTapped(button:)), for: .touchUpInside)

            // Add button to the stack
            addArrangedSubview(button)

            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()

    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index == rating - 1
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            default:
                valueString = "Mood \(rating) set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }

}

