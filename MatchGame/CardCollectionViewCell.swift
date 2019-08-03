//
//  CardCollectionViewCell.swift
//  MatchGame
//
//  Created by Juhi A on 7/24/19.
//  Copyright © 2019 Juhi A. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImage: UIImageView!
    
    @IBOutlet weak var backImage: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card)
    {
        self.card = card;
        frontImage.image = UIImage(named: card.imageId)
        
        if card.matched == true
        {
            frontImage.alpha = 0
            backImage.alpha = 0
            
            return
        }
        else
        {
            frontImage.alpha = 1
            backImage.alpha = 1
        }
        // cards should not be reset because of re-using the cells
        if(card.flipped)
        {
            UIView.transition(from: backImage, to: frontImage, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else
        {
             UIView.transition(from: frontImage, to: backImage, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip()
    {
        UIView.transition(from: backImage, to: frontImage, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImage, to: self.backImage, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func remove()
    {
            self.backImage.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
                self.frontImage.alpha = 0
            }, completion: nil)
    }
}
