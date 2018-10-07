//
//  LeagueTeamsState.swift
//  ReFoot
//
//  Created by merengue on 07/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

struct LeagueTeamsState {
    var leagueTeams: [String: Loadable<EquatableArray<Team>>]
    
    func areTeamsLoaded(for league: League) -> Bool {
        guard let teamsInLeague = leagueTeams[league.id] else {
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

let initialLeagueTeamsState = LeagueTeamsState(leagueTeams: [:])
