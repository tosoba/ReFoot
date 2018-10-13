//
//  LeagueTeamsTableViewSection.swift
//  ReFoot
//
//  Created by merengue on 13/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxDataSources

struct LeagueTeamsTableViewSection {
    var title: String
    var teams: [Team]
}

extension LeagueTeamsTableViewSection : IdentifiableType {
    public typealias Identity = String
    
    var identity: String { return title }
}

extension LeagueTeamsTableViewSection: AnimatableSectionModelType {
    var items: [Team] {
        return teams
    }
    
    typealias Item = Team
    
    init(original: LeagueTeamsTableViewSection, items: [Item]) {
        self = original
        self.teams = items
    }
}
