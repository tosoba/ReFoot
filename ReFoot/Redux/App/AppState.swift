//
//  AppState.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

struct AppState: StateType {
    let leaguesState: LeaguesState
    let dayEventsState: DayEventsState
    let scoresHostState: ScoresHostState
    let livescoresState: LivescoresState
}

let initialAppState = AppState(
    leaguesState: initialLeaguesState,
    dayEventsState: initialDayEventsState,
    scoresHostState: initialScoresHostState,
    livescoresState: initialLivescoreState
)
