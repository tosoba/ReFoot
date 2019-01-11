//
//  DayEventsMiddleware.swift
//  ReFoot
//
//  Created by merengue on 06/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func dayEventsMiddleware(using repository: FootballRepository) -> SimpleMiddleware<AppState> {
    return { (action, context) in
        handleDayEventsAction(action, in: context, using: repository)
    }
}

private func handleDayEventsAction(_ action: Action, in context: MiddlewareContext<AppState>, using repository: FootballRepository) -> Action? {
    guard let fetchDayEventsAction = action as? DayEventsAction, case .fetch(let date) = fetchDayEventsAction else { return action }
    
    if context.state?.dayEventsState.areEventsLoaded(for: date) == true {
        return action
    }
    
    context.dispatch(DayEventsAction.set(.loading, date))
    
    repository.getMatchEvents(on: date, thenOnSuccess: { matchEvents in
        context.dispatch(DayEventsAction.set(.value(EquatableArray(data: matchEvents)), date))
    }, orOnError: { error in
        context.dispatch(DayEventsAction.set(.error(error), date))
    })
 
    return nil
}
