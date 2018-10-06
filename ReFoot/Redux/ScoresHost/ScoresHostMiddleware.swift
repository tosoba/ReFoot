//
//  ScoresHostMiddleware.swift
//  ReFoot
//
//  Created by merengue on 06/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

var scoresHostMiddleware: SimpleMiddleware<AppState> {
    return { changeScoresHostDate(action: $0, context: $1) }
}

func changeScoresHostDate(action: Action, context: MiddlewareContext<AppState>) -> Action? {
    guard let changeScoresHostDateAction = action as? ScoresHostAction, case .set(let date) = changeScoresHostDateAction else { return action }
    context.dispatch(DayEventsAction.fetch(date))
    return action
}
