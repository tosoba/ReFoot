//
//  LeagueTeamsReducer.swift
//  ReFoot
//
//  Created by merengue on 07/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func leagueTeamsReducer(action: Action, state: LeagueTeamsState?) -> LeagueTeamsState {
    var currentState = state ?? initialLeagueTeamsState
    guard let leagueTeamsAction = action as? LeagueTeamsAction else {
        return currentState
    }
    
    switch leagueTeamsAction {
    case .set(let loadable, let league):
        currentState.leagueTeams[league.id] = loadable
    default:
        break
    }
    
    return currentState
}
