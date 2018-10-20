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
    var tables: [String: Loadable<EquatableArray<LeagueTableTeam>>]
    
    func areTeamsLoaded(for league: League) -> Bool {
        guard let teamsInLeague = teams[league.id] else { return false }
        return teamsInLeague.isValueSet
    }
    
    func isTableLoaded(for league: League) -> Bool {
        guard let table = tables[league.id] else { return false }
        return table.isValueSet
    }
}

let initialLeaguesState = LeaguesState(leaguesLoadable: .initial, selectedLeague: nil, teams: [:], tables: [:])
