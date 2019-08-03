//
//  ViewController.swift
//  MatchGame
//
//  Created by Juhi A on 7/24/19.
//  Copyright © 2019 Juhi A. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var model = CardManager()
    var cardToDisplay = [Card]()
    
    // check if the
    var firstFlipped:IndexPath?
    
    var totalTime:Float = 20000
    var milliSeconds:Float = 10
    var timer:Timer?
    
    var soundManager = SoundManager()
    
     @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        milliSeconds = totalTime
        cardToDisplay = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timeElapsed), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        // Do any additional setup after loading the view.
        
    }
    
    func fetchData(_ context:NSManagedObjectContext)
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
                print(data.value(forKey: "time") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundManager.Play(.shuffle)
    }
    
    @objc func timeElapsed()
    {
        milliSeconds -= 1;
        
        // convert to string
        let seconds = String(format: "%.2f", milliSeconds/1000)
        
        timerLabel.text = "Time Remaining: \(seconds)"
        
        if milliSeconds <= 0
        {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            CheckGameEnded()
        }
    }
    
    // uiCollectionView Protocol methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoreCell", for: indexPath) as! CardCollectionViewCell
        
        //let card
        cell.setCard(cardToDisplay[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliSeconds <= 0
        {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        let card = cardToDisplay[indexPath.row]
        
        if(!card.flipped && !card.matched)
        {
            cell?.flip()
            soundManager.Play(.flip)
            
            card.flipped = true
            
            if firstFlipped == nil
            {
                firstFlipped = indexPath
            }
            else
            {
                let cellX = collectionView.cellForItem(at: firstFlipped!) as? CardCollectionViewCell
                let cardX = cardToDisplay[firstFlipped!.row]
                
                if card.imageId == cardX.imageId
                {
                    soundManager.Play(.match)
                    card.matched = true;
                    cardX.matched = true
                    
                    // make the two cards disappear
                    cell?.remove()
                    cellX?.remove()
                    
                    CheckGameEnded()
                
                }
                else
                {
                    soundManager.Play(.noMatch)
                    card.flipped = false;
                    cardX.flipped = false;
                    
                    cell?.flipBack()
                    //soundManager.Play(.flip)
                    
                    cellX?.flipBack()
                    //soundManager.Play(.flip)
                }
                
                // reload first cell if it was nil after re-use of cell by collection view
                if cellX == nil
                {
                    collectionView.reloadItems(at: [firstFlipped!])
                }
                firstFlipped = nil
            }
        }
    }
    
    func CheckGameEnded()
    {
        var title = ""
        var message = ""
        
        var isWon = true;
        
        for card in cardToDisplay
        {
            if card.matched ==  false
            {
                isWon = false
                break
            }
        }
        
        if isWon
        {
            if milliSeconds > 0
            {
                timer?.invalidate()
                title = "Congratulations"
                message = "You have won"
            }
            
            saveScore(milliSeconds)
        }
        else
        {
            if milliSeconds > 0
            {
                return
            }
            title  = "Game  Over"
            message = "Better Luck next time"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveScore(_ timeLeft:Float)
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Score", in: context)
        
        let newScore = NSManagedObject(entity: entity!, insertInto: context)
        
        newScore.setValue("aaa", forKey: "name")
        
        var timeCompl = "\(totalTime - timeLeft)"
        newScore.setValue(timeCompl, forKey: "time")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        fetchData(context)
    }
}

