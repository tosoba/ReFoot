//
//  DayEventsState.swift
//  ReFoot
//
//  Created by merengue on 06/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

struct DayEventsState: StateType {
    var events: [String: Loadable<EquatableArray<MatchEvent>>]
    
    func areEventsLoaded(for date: Date) -> Bool {
        guard let eventsForDate = events[date.toStringYearMonthDay()] else { return false }
        switch eventsForDate {
        case .value(_):
            return true
        default:
            return false
        }
    }
}

let initialDayEventsState = DayEventsState(events: [
    Date.today.offsetBy(days: -2).toStringYearMonthDay() : .initial,
    Date.today.offsetBy(days: -1).toStringYearMonthDay() : .initial,
    Date.today.offsetBy(days: 1).toStringYearMonthDay() : .initial,
    Date.today.offsetBy(days: 2).toStringYearMonthDay() : .initial
])

