//
//  ViewController.swift
//  set
//
//  Created by Alexander Konovalov on 08.02.2021.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateViewFromModel()
  }
  
  private lazy var game = Set()
  
  @IBOutlet private var cardButtons: [UIButton]!
  
  private func isSet() -> Bool {
    if game.selectedCards.count == 3 {
      if cardButtons[0].currentTitle == cardButtons[1].currentTitle,
         cardButtons[0].currentTitle == cardButtons[2].currentTitle {
        game.isSet = true
        return true
      }
    }
    game.isSet = false
    return false
  }
  
  @IBAction func DealCardsButton(_ sender: UIButton) {
    game.dealThreeCards()
    updateViewFromModel()
  }
  
  @IBAction func touchCard(_ sender: UIButton) {
    if let cardNumber = cardButtons.firstIndex(of: sender) {
      isSet()
      game.chooseCard(at: cardNumber)
      updateViewFromModel()
    }
  }
  
  
  
  private func updateViewFromModel() {
    for index in cardButtons.indices {
      let button = cardButtons[index]
      
      if game.playingCards.indices.contains(index) {
        //Card exist in game
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        //        button.setTitle("figure", for: UIControl.State.normal)
        
        let card = game.playingCards[index]
        if game.selectedCards.contains(card) { // Card is selected
          button.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
          //          button.setTitle("selected", for: UIControl.State.normal)
        }
      } else { // Card is not in the game
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        button.setTitle("", for: UIControl.State.normal)
      }
      
    }
  }
  
}

