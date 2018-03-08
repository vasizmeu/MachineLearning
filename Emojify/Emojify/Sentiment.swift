//
//  Copyright © 2018 Vasilica Costescu. All rights reserved.
//

enum Sentiment {
    case happy
    case neutral
    case sad
    
    var emoji: String {
        switch self {
        case .neutral:
            return "😐"
        case .happy:
            return "😃"
        case .sad:
            return "😔"
        }
    }
    
    var imageName: String {
        switch self {
        case .neutral:
            return "neutral"
        case .happy:
            return "happy"
        case .sad:
            return "sad"
        }
    }
}

