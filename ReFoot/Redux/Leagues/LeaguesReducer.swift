//
//  LeaguesListReducer.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func leaguesReducer(action: Action, state: LeaguesState?) -> LeaguesState {
    var currentState = state ?? initialLeaguesState
    guard let leaguesAction = action as? LeaguesAction else { return currentState }
    
    switch leaguesAction {
    case .setLeagues(let loadableLeagues):
        currentState.leaguesLoadable = loadableLeagues
    case .selectLeague(let league):
        currentState.selectedLeague = league
    case .setTeamsForLeague(let loadableTeams, let league):
        currentState.teams[league.id] = loadableTeams
    case .setTableForLeague(let loadableLeagueTableTeams, let league):
        currentState.tables[league.id] = loadableLeagueTableTeams
    default:
        break
    }
    
    return currentState
}
