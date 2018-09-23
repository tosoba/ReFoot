//
//  AppState.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    let leaguesListState: LeaguesListState
}

let initialAppState = AppState(
    leaguesListState: initialLeaguesState
)
