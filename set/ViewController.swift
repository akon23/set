//
//  ViewController.swift
//  set
//
//  Created by Alexander Konovalov on 08.02.2021.
//

import UIKit

class ViewController: UIViewController{
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fillGameCardViews()
    updateViewFromModel()
  }
  
  @IBOutlet private var cardButtons: [UIButton]!
  
  @IBOutlet weak var dealCardsButton: UIButton! {
    didSet {
      dealCardsButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
  }
  
  @IBAction func dealCardsButtonAction() {
    isSet() ? game.updateThreeCards() : game.dealThreeCards()
    updateViewFromModel()
  }
  
  
  @IBAction func newGameButton() { // Not working
    gameCardViewContainer.removeAll()
    fillGameCardViews()
    updateViewFromModel()
  }
  
  @IBOutlet weak var scoreLabel: UILabel!
  
  @IBAction func touchCard(_ sender: UIButton) {
    if let cardNumber = cardButtons.firstIndex(of: sender) {
      if isSet() {
        game.updateThreeCards()
      }
      game.chooseCard(at: cardNumber)
      updateViewFromModel()
    }
  }
  
  private lazy var game = Set()
  
  private var scoreCount = 0 {
    didSet {
      scoreLabel.text = "Score: \(scoreCount)"
    }
  }
  
  private func isSet() -> Bool {
    if game.selectedCards.count == 3 {
      var cards = [cardViewType]()
      for card in game.selectedCards {
        cards.append(attributedCardTitle[card]!.cardView)
      }

      let sum = [ cards.reduce(0, { $0 + colors[$1.color]! }), // check closure
      cards.reduce(0, { $0 + $1.figure.getNumber() }),
      cards.reduce(0, { $0 + $1.figuresCount.rawValue }),
      cards.reduce(0, { $0 + $1.visibility.getNumber() }) ]
      return sum.reduce(true, { $0 && ($1 % 3 == 0) })
    }
    return false
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
          if game.selectedCards.count == 3 {
            button.layer.borderWidth = 4.0
            if isSet() {
              scoreCount += 1
              button.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else {
              scoreCount -= 1
              button.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
          } else {
            button.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
          }
        }
      } else { // Card is not in the game
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        button.setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
      }
    }
  }
  
  private var gameCardViewContainer = [GameCardView]()
  private func fillGameCardViews() {
    let figures: [Figures] = [.circle, .square, .triangle]
    let visibilities: [FigureVisibility : Int] = [.empty : 7, .stripped : 0, .fill : -1]
    let count: [FiguresCount] = [.one, .two, .three]
    
    for count in count {
      for figure in figures {
        for color in colors.keys {
          for visibility in visibilities {
            let attributes: [NSAttributedString.Key:Any] = [
              .foregroundColor : color.withAlphaComponent(CGFloat(visibility.key.rawValue)),
              .strokeWidth : visibility.value,
              .strokeColor : color
            ]
            gameCardViewContainer.append(GameCardView(cardViewProperties: (NSAttributedString(string: String(repeating: figure.rawValue, count: count.rawValue), attributes: attributes), figure, color, visibility.key, count)))
          }
        }
      }
    }
  }
  
  private var attributedCardTitle = [Card:GameCardView]() //  Dictionary - Link Card and View
  
  private func attributedTitle(for card: Card) -> NSAttributedString {
    if attributedCardTitle[card] == nil, gameCardViewContainer.count > 0 {
      let randomStringIndex = gameCardViewContainer.index(gameCardViewContainer.startIndex, offsetBy: gameCardViewContainer.count.arc4random)
      attributedCardTitle[card] = (gameCardViewContainer.remove(at: randomStringIndex))
    }
    return attributedCardTitle[card]?.cardView.attributedString ?? NSAttributedString(string: "?")
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
