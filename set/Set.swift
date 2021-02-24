//
//  Set.swift
//  set
//
//  Created by Alexander Konovalov on 08.02.2021.
//

import Foundation

struct Set {
  private(set) var playingCards = [Card]()
  private(set) var dealCards = [Card]()
  private(set) var selectedCards = [Card]()
  
  var isSet: Bool
  
  init() {
    isSet = false
    for _ in 0..<12 {
      let card = Card()
      playingCards += [card]
    }
    for _ in 0..<69 {
      let card = Card()
      dealCards += [card]
    }
    
  }
  
  mutating func dealThreeCards() {
    if !isSet, playingCards.count < 22 {
      for _ in 0...2 {
        playingCards.append(dealCards.remove(at: dealCards.count.arc4random))
      }
    } else if isSet {
      for i in selectedCards.indices {
        if let index = playingCards.firstIndex(of: selectedCards[i]){
          playingCards[index] = dealCards.remove(at: dealCards.count.arc4random)
        }
      }
      selectedCards.removeAll()
      isSet = false
    }
  }
  
  mutating func chooseCard(at index: Int) {
    //    assert(playingCards.indices.contains(index), "Set.chooseCard: \(index): chosen card is not in the game")
    if playingCards.indices.contains(index) {
      if isSet { // Не надо добавлять если сета не было
        dealThreeCards()
      }
      
      let card = playingCards[index]
      
      if let selectedIndex = selectedCards.firstIndex(of: card) {
        selectedCards.remove(at: selectedIndex)
      } else {
        selectedCards.append(playingCards[index])
      }
    } else {
      print("Set.chooseCard: \(index): chosen card is not in the game")
    }
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
