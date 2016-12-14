//
//  ViewController.swift
//  Project37
//
//  Created by Jonathan Deguzman on 12/8/16.
//  Copyright © 2016 Jonathan Deguzman. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gradientView: GradientVIew!
    @IBOutlet weak var cardContainer: UIView!

    var allCards = [CardViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        
        UIView.animate(withDuration: 20, delay: 0, options: [.allowUserInteraction, .autoreverse, .repeat], animations: {
            self.view.backgroundColor = UIColor.blue
        })
        
        createParticles()
        loadCards()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// loadCards() assembles an array of positions where the cards need to go, loads the various zener shapes, and creates one card view controller for each position.
    /// - Returns: nil
    /// - Parameters: none
    
    func loadCards() {
        view.isUserInteractionEnabled = true
        
        // Remove any existing cards by looping through the card view controllers stored in the allCards array, remove the view, remove the view controller containment, and then clear the whole array.
        for card in allCards {
            card.view.removeFromSuperview()
            card.removeFromParentViewController()
        }
        
        allCards.removeAll(keepingCapacity: true)
        
        let positions = [
            CGPoint(x: 75, y: 85),
            CGPoint(x: 185, y: 85),
            CGPoint(x: 295, y: 85),
            CGPoint(x: 405, y: 85),
            CGPoint(x: 75, y: 235),
            CGPoint(x: 185, y : 235),
            CGPoint(x: 295, y: 235),
            CGPoint(x: 405, y: 235)
        ]
        
        // Load and unwrap the zener card images.
        let circle = UIImage(named: "cardCircle")!
        let cross = UIImage(named: "cardCross")!
        let lines = UIImage(named: "cardLines")!
        let square = UIImage(named: "cardSquare")!
        let star = UIImage(named: "cardStar")!
        
        // Create an array of the images, one for each card, and shuffle them.
        var images = [circle, circle, cross, cross, lines, lines, square, square, star, star]
        images = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: images) as! [UIImage]
        
        for (index, position) in positions.enumerated() {
            // Loop over each card position and create a new card view controller.
            let card = CardViewController()
            card.delegate = self
            
            // Use view controller containment to place one view inside another.
            addChildViewController(card)
            cardContainer.addSubview(card.view)
            card.didMove(toParentViewController: self)
            
            // Position the card appropriately, then give it an image form the array.
            card.view.center = position
            card.front.image = images[index]
            
            if card.front.image == star {
                card.isCorrect = true
            }
            
            allCards.append(card)
        }
    }
    
    func cardTapped(_ tapped: CardViewController) {
        // As soon as any card is tapped, disable user interaction from the main view.
        guard view.isUserInteractionEnabled == true else { return }
        view.isUserInteractionEnabled = false
       
        // Loop through all the cards in our array until we get to the card that was tapped and tehn we flip it over. All other cards just fade away.
        for card in allCards {
            if card == tapped {
                card.wasTapped()
                card.perform(#selector(card.wasntTapped), with: nil, afterDelay: 1)
            } else {
                card.wasntTapped()
            }
        }
        
        perform(#selector(loadCards), with: nil, afterDelay: 2)
    }
    
    /// createParticles() uses CAEmitterLayer to create falling stars in the background.
    /// - Returns: nil
    /// - Parameters: nil
    
    func createParticles() {
        // Set the properties for the particle system.
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: view.frame.width / 2.0, y: -50)
        particleEmitter.emitterShape = kCAEmitterLayerLine
        particleEmitter.emitterSize = CGSize(width: view.frame.width, height: 1)
        particleEmitter.renderMode = kCAEmitterLayerAdditive
        
        
        // Set the properties for the emitter cells.
        let cell = CAEmitterCell()
        
        cell.birthRate = 2
        cell.lifetime = 5.0
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.spinRange = 5
        cell.scale = 0.5
        cell.scaleRange = 0.25
        cell.color = UIColor(white: 1, alpha: 0.1).cgColor
        cell.alphaSpeed = -0.025
        cell.contents = UIImage(named: "particle")?.cgImage
        
        particleEmitter.emitterCells = [cell]
        
        gradientView.layer.addSublayer(particleEmitter)
    }
    
}

