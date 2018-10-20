//
//  LeagueTeamsTableViewCell.swift
//  ReFoot
//
//  Created by merengue on 13/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import FoldingCell
import Kingfisher

class LeagueTeamsTableViewCell: FoldingCell {
    
    static let identifier = "leagueTeamsTableViewCell"
    
    @IBOutlet weak var teamNameForegroundLabel: UILabel!
    @IBOutlet weak var teamBadgeImageView: UIImageView!
    
    @IBOutlet weak var teamBannerImageView: UIImageView!
    @IBOutlet weak var teamJerseyImageView: UIImageView!
    @IBOutlet weak var teamNameContainerLabel: UILabel!
    
    private let animationDurations = [0.33, 0.26, 0.26]
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        return animationDurations[itemIndex]
    }
}
