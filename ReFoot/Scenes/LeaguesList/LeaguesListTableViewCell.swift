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
    
    var badgeURL: String? {
        didSet {
            guard let urlString = badgeURL else { return }
            leagueBadgeImageView.kf.setImage(with: URL(string: urlString))
        }
    }
    
    @IBOutlet weak var leagueBadgeImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
}
