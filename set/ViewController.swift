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
    createAttributedTitle()
    updateViewFromModel()
  }
  
  private lazy var game = Set()
  
  @IBOutlet private var cardButtons: [UIButton]!
  
  private func isSet() -> Bool {
    if game.selectedCards.count == 3 {
      if cardButtons[0].currentTitle == cardButtons[1].currentTitle,
         cardButtons[0].currentTitle == cardButtons[2].currentTitle {
        return true
      }
    }
    return false
  }
  
  @IBOutlet weak var dealCardsButton: UIButton! {
    didSet {
      dealCardsButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
  }
  
  @IBAction func dealCardsButtonAction() {
    isSet() ? game.updateThreeCards() : game.dealThreeCards()
    updateViewFromModel()
  }
  
  @IBAction func touchCard(_ sender: UIButton) {
    if let cardNumber = cardButtons.firstIndex(of: sender) {
      if isSet() { // привести в соответствие с правилами (Ну вроде норм)
        game.updateThreeCards()
      }
      game.chooseCard(at: cardNumber)
      updateViewFromModel()
    }
  }
  
  private func updateViewFromModel() {
    
    if game.dealCards.isEmpty { // Deal 3 cards button is not available
      dealCardsButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.4519151094)
      dealCardsButton.setTitle("", for: UIControl.State.normal)
    }
    
    for index in cardButtons.indices {
      let button = cardButtons[index]
      button.layer.cornerRadius = 8.0
      
      if game.playingCards.indices.contains(index) { // Card exist in game
        let card = game.playingCards[index]
        button.setAttributedTitle(attributedTitle(for: card), for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.layer.borderWidth = 3.0
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        if game.selectedCards.contains(card) { // Card is Selected
          if isSet() {
            button.layer.borderWidth = 4.0
            button.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
          } else {
            button.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
          }
        }
      } else { // Card is not in the game
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
      }
    }
    //        button.setTitle("figure", for: UIControl.State.normal)
  }
  
  private var attributedTitles = [NSAttributedString]()
  
  enum Figures: String {
    case circle = "●"
    case square = "■"
    case triangle = "▲"
  }

  private func createAttributedTitle(){
    let figures: [Figures] = [.circle, .square, .triangle]
    let colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)]
    let alphas = [0, 0.5, 1]
    let strokeWidth = [10, 0, -1]
    for count in 1...3 { // 3
      for figure in figures { // 3
        for color in colors { // 3
          for index in 0...2 { // 3
            let attributes: [NSAttributedString.Key:Any] = [
              .foregroundColor : color.withAlphaComponent(CGFloat(alphas[index])),
              .strokeWidth : strokeWidth[index],
              .strokeColor : color,
            ]
            attributedTitles.append(NSAttributedString(string: String(repeating: figure.rawValue, count: count), attributes: attributes))
          }
        }
      }
    }
  }
  
  private var attributedTitle = [Card:NSAttributedString]() //  Dictionary
  
  private func attributedTitle(for card: Card) -> NSAttributedString {
    if attributedTitle[card] == nil, attributedTitles.count > 0 {
      let randomStringIndex = attributedTitles.index(attributedTitles.startIndex, offsetBy: attributedTitles.count.arc4random)
      attributedTitle[card] = (attributedTitles.remove(at: randomStringIndex))
    }
    return attributedTitle[card] ?? NSAttributedString(string: "?")
  }
  
}

extension Int {
  var arc4random: Int {
    if self > 0 {
      return Int(arc4random_uniform(UInt32(self)))
    } else if self < 0 {
      return -Int(arc4random_uniform(UInt32(self)))
    } else {
      return 0
    }
  }
}
