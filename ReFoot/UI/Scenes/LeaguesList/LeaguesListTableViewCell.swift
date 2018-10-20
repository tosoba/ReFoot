//
//  LeaguesListTableViewCell.swift
//  ReFoot
//
//  Created by merengue on 29/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import Kingfisher

final class LeaguesListTableViewCell: UITableViewCell {
    
    static let identifier = "leaguesListTableViewCell"
    
    @IBOutlet weak var leagueBadgeImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
}
