//
//  LeagueTeamsAction.swift
//  ReFoot
//
//  Created by merengue on 07/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

enum LeagueTeamsAction: Action {
    case fetch(League)
    case set(Loadable<EquatableArray<Team>>, League)
}
