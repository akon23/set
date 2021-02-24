//
//  Card.swift
//  set
//
//  Created by Alexander Konovalov on 08.02.2021.
//

import Foundation

struct Card: Equatable {
  
  private(set) var identifier: Int
  
  private static var identifierFactory = 0;
  private static func getUniqueIdentifier() -> Int {
    identifierFactory += 1
    return identifierFactory
  }
  
  init() {
    self.identifier = Card.getUniqueIdentifier()
  }
  
}

extension Card {
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}

