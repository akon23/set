import UIKit


let colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1): 1, #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1): 2, #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1): 3]

enum Figures: String {
  case circle = "●"
  case square = "■"
  case triangle = "▲"
  
  func getNumber() -> Int {
    switch self {
    case .circle: return 1
    case .square: return 2
    case .triangle: return 3
    }
  }
}

enum FigureVisibility: Double {
  case fill = 1.0
  case stripped = 0.5
  case empty = 0
  
  func getNumber() -> Int {
    switch self {
    case .empty: return 1
    case .stripped: return 2
    case .fill: return 3
    }
  }
}

enum FiguresCount: Int {
  case one = 1
  case two
  case three
}

typealias cardViewType = (attributedString: NSAttributedString, figure: Figures, color: UIColor, visibility: FigureVisibility, figuresCount: FiguresCount)
class GameCardView {
  let cardView: cardViewType
  
  init(cardViewProperties cardViewType: cardViewType) {
    self.cardView = cardViewType
  }
}
