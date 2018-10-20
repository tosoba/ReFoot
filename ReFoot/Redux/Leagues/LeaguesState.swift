//
//  LeaguesState.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import ReSwift

struct LeaguesState: StateType {
    var leaguesLoadable: Loadable<EquatableArray<League>>
    var selectedLeague: League?
    var teams: [String: Loadable<EquatableArray<Team>>]
    
    func areTeamsLoaded(for league: League) -> Bool {
        guard let teamsInLeague = teams[league.id] else {
            return false
        }
        switch teamsInLeague {
        case .value(_):
            return true
        default:
            return false
        }
    }
}

let initialLeaguesState = LeaguesState(leaguesLoadable: .initial, selectedLeague: nil, teams: [:])
