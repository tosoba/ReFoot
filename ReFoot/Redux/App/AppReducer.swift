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
        leaguesState: leaguesReducer(action: action, state: state?.leaguesState),
        dayEventsState: dayEventsReducer(action: action, state: state?.dayEventsState),
        scoresHostState: scoresHostReducer(action: action, state: state?.scoresHostState),
        livescoresState: livescoresReducer(action: action, state: state?.livescoresState)
    )
}
