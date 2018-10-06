//
//  DayEventsMiddleware.swift
//  ReFoot
//
//  Created by merengue on 06/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func dayEventsMiddleware(using repository: FootballRepository) -> SimpleMiddleware<AppState> {
    return { fetchDayEvents(action: $0, context: $1, repository: repository) }
}

private func fetchDayEvents(action: Action, context: MiddlewareContext<AppState>, repository: FootballRepository) -> Action? {
    guard let fetchDayEventsAction = action as? DayEventsAction, case .fetch(let date) = fetchDayEventsAction else { return action }
    
    if context.state?.dayEventsState.areEventsLoaded(for: date) == true || Date.today.isTheSameDay(as: date) {
        return action
    }
    
    context.dispatch(DayEventsAction.set(Loadable.loading, date))
    
    repository.getMatchEvents(on: date, thenOnSuccess: { matchEvents in
        context.dispatch(DayEventsAction.set(Loadable.value(EquatableArray(data: matchEvents)), date))
    }, orOnError: { error in
        context.dispatch(DayEventsAction.set(Loadable.error(error), date))
    })
 
    return nil
}
