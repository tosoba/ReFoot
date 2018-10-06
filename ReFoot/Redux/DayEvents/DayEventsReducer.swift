//
//  DayEventsReducer.swift
//  ReFoot
//
//  Created by merengue on 06/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func dayEventsReducer(action: Action, state: DayEventsState?) -> DayEventsState {
    var currentState = state ?? initialDayEventsState
    guard let dayEventsAction = action as? DayEventsAction else {
        return currentState
    }
    
    switch dayEventsAction {
    case .set(let loadable, let date):
        currentState.events[date.toStringYearMonthDay()] = loadable
    default:
        break
    }
    
    return currentState
}
