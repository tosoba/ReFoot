//
//  DayEventsAction.swift
//  ReFoot
//
//  Created by merengue on 06/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

enum DayEventsAction: Action {
    case fetch(Date)
    case set(Loadable<EquatableArray<MatchEvent>>, Date)
}
