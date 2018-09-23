//
//  LeaguesListReducer.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func leaguesListReducer(action: Action, state: LeaguesListState?) -> LeaguesListState {
    var currentState = state ?? initialLeaguesState
    guard let leaguesListAction = action as? LeaguesListAction else {
        return currentState
    }
    
    switch leaguesListAction {
    case .set(let loadable):
        currentState.leagues = loadable
    default:
        break
    }
    
    return currentState
}
