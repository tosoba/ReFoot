//
//  LeagueTeamsTableViewCell.swift
//  ReFoot
//
//  Created by merengue on 13/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import FoldingCell

class LeagueTeamsTableViewCell: FoldingCell {
    
    static let identifier = "leagueTeamsTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }

}
