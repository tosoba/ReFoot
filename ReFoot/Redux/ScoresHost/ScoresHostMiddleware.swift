//
//  ScoresHostMiddleware.swift
//  ReFoot
//
//  Created by merengue on 06/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

var scoresHostMiddleware: SimpleMiddleware<AppState> {
    return { (action, context) in
        handleScoresHostAction(action, in: context)
    }
}

private func handleScoresHostAction(_ action: Action, in context: MiddlewareContext<AppState>) -> Action? {
    guard let scoresHostAction = action as? ScoresHostAction, case .set(let date) = scoresHostAction else { return action }
    context.dispatch(DayEventsAction.fetch(date))
    return action
}
