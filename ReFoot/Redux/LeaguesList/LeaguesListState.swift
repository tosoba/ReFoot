//
//  LeaguesState.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import ReSwift

struct LeaguesListState: StateType {
    var leaguesLoadable: Loadable<EquatableArray<League>>
    var selectedLeague: League?
}

let initialLeaguesState = LeaguesListState(leaguesLoadable: .initial, selectedLeague: nil)
