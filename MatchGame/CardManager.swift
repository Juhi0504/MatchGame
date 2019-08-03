//
//  CardModel.swift
//  MatchGame
//
//  Created by Juhi A on 7/24/19.
//  Copyright © 2019 Juhi A. All rights reserved.
//

import Foundation

class CardManager {
    
    func getCards() -> [Card] {
        
        var randomCards = [Card]()
        var index = [Int]()
        
        repeat {
            
            var rand = arc4random_uniform(13) + 1
            
            if(!index.contains(Int(rand)))
            {
                print(rand)
                index.append(Int(rand))
                var card1:Card = Card()
                card1.imageId = "card\(rand)"
                
                randomCards.append(card1)
                
                var card2:Card = Card()
                card2.imageId = "card\(rand)"
                
                randomCards.append(card2)
            }
            
        } while randomCards.count < 16
    
        /*for i in 1...8 {
            
            // arc4random_uniform(13)  --> 0-12
            var rand = arc4random_uniform(13) + 1
            
            var card1:Card = Card()
            card1.imageId = "card\(rand)"
            
            randomCards.append(card1)
            
            var card2:Card = Card()
            card2.imageId = "card\(rand)"
            
            randomCards.append(card2)
        }*/
        
        randomCards.shuffle()
        
        return randomCards
    }
    
}
