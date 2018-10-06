//
//  AppReducer.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        leaguesListState: leaguesListReducer(action: action, state: state?.leaguesListState),
        dayEventsState: dayEventsReducer(action: action, state: state?.dayEventsState),
        scoresHostState: scoresHostReducer(action: action, state: state?.scoresHostState)
    )
}
