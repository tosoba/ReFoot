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
    let dayEventsState: DayEventsState
    let scoresHostState: ScoresHostState
    let leagueTeamsState: LeagueTeamsState
}

let initialAppState = AppState(
    leaguesListState: initialLeaguesState,
    dayEventsState: initialDayEventsState,
    scoresHostState: initialScoresHostState,
    leagueTeamsState: initialLeagueTeamsState
)
