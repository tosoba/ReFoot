//
//  LeaguesListTableViewSection.swift
//  ReFoot
//
//  Created by merengue on 29/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxDataSources

struct LeaguesListTableViewSection {
    var title: String
    var leagues: [League]
}

extension LeaguesListTableViewSection : IdentifiableType {
    public typealias Identity = String
    
    var identity: String { return title }
}

extension LeaguesListTableViewSection: AnimatableSectionModelType {
    var items: [League] {
        return leagues
    }
    
    typealias Item = League
    
    init(original: LeaguesListTableViewSection, items: [Item]) {
        self = original
        self.leagues = items
    }
}
