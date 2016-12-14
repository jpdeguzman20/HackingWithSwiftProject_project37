//
//  CardViewController.swift
//  Project37
//
//  Created by Jonathan Deguzman on 12/8/16.
//  Copyright © 2016 Jonathan Deguzman. All rights reserved.
//

import UIKit
import GameplayKit

class CardViewController: UIViewController {

    weak var delegate: ViewController!
    
    var front: UIImageView!
    var back: UIImageView!
    
    var isCorrect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.bounds = CGRect(x: 0, y: 0, width: 100, height: 140)
        front = UIImageView(image: UIImage(named: "cardBack"))
        back = UIImageView(image: UIImage(named: "cardBack"))
        
        view.addSubview(front)
        view.addSubview(back)
        
        front.isHidden = true
        back.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.back.alpha = 1
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        back.isUserInteractionEnabled = true
        back.addGestureRecognizer(tap)
        
        // Initial call to the wiggle method to make cards move
        perform(#selector(wiggle), with: nil, afterDelay: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cardTapped() {
        delegate.cardTapped(self)
    }
    
    /// wasntTapped() tells a card to zoom away over a period of 0.7 seconds.
    /// - Returns: nil
    /// - Parameters: none
    
    func wasntTapped() {
        UIView.animate(withDuration: 0.7) {
            self.view.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
            self.view.alpha = 0
        }
    }
    
    /// wasTapped() flips a single card from the right over a period of 0.7 seconds.
    /// - Returns: nil
    /// - Parameters: none
    
    func wasTapped() {
        UIView.transition(with: view, duration: 0.7, options: [.transitionFlipFromRight], animations: { [unowned self] in
            self.back.isHidden = true
            self.front.isHidden = false
        })
    }

    func wiggle() {
        if GKRandomSource.sharedRandom().nextInt(upperBound: 4) == 1 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
                // Scale the card so that it is 1% more than normal to trick the user's sight.
                self.back.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
            }) { _ in
                // Drop it back down to its normal size
                self.back.transform = CGAffineTransform.identity
            }
            
            // Call this method over again
            perform(#selector(wiggle), with: nil, afterDelay: 8)
        } else {
            perform(#selector(wiggle), with: nil, afterDelay: 2)
        }
    }

}
