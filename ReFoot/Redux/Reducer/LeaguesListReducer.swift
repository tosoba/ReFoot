//
//  LeaguesListReducer.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func leaguesListReducer(action: Action, state: LeaguesListState?) -> LeaguesListState {
    return state ?? initialLeaguesState
}
