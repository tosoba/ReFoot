//
//  LeaguesListModels.swift
//  ReFoot
//
//  Created by merengue on 29/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxDataSources

struct LeagueSection {
    var title: String
    var leagues: [League]
}

extension LeagueSection : IdentifiableType {
    public typealias Identity = String
    
    var identity: String { return title }
}

extension LeagueSection: AnimatableSectionModelType {
    var items: [League] {
        return leagues
    }
    
    typealias Item = League
    
    init(original: LeagueSection, items: [Item]) {
        self = original
        self.leagues = items
    }
}
