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
  
  init() {
    for _ in 0..<12 {
      let card = Card()
      playingCards += [card]
    }
    for _ in 0..<69 {
      let card = Card()
      dealCards += [card]
    }
    
  }
  
  mutating func updateThreeCards() {
    for i in selectedCards.indices {
      if let index = playingCards.firstIndex(of: selectedCards[i]) {
        if !dealCards.isEmpty {
          playingCards[index] = dealCards.remove(at: dealCards.count.arc4random)
        } else {
          playingCards.remove(at: index)
        }
      }
    }
    selectedCards.removeAll()
  }
  
  mutating func dealThreeCards() {
    if playingCards.count < 22, !dealCards.isEmpty {
      for _ in 0...2 {
        playingCards.append(dealCards.remove(at: dealCards.count.arc4random))
      }
    }
  }
  
  mutating func chooseCard(at index: Int) {
    //    assert(playingCards.indices.contains(index), "Set.chooseCard: \(index): chosen card is not in the game")
    if selectedCards.count == 3 {
      selectedCards.removeAll()
    }
    
    if playingCards.indices.contains(index) {
      
      let card = playingCards[index]
      
      if let selectedIndex = selectedCards.firstIndex(of: card) {
        selectedCards.remove(at: selectedIndex)
      } else {
        selectedCards.append(playingCards[index])
      }
    } else {
//      print("Set.chooseCard: \(index): chosen card is not in the game")
    }
  }
  
}
