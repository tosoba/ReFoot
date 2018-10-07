//
//  LeaguesAction.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

enum LeaguesListAction: Action {
    case fetch
    case set(Loadable<EquatableArray<League>>)
    case selectLeague(League)
}
