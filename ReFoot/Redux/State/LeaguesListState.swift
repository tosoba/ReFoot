//
//  LeaguesState.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import ReSwift

struct LeaguesListState: StateType {
    let leagues: Loadable<[League]>
}

let initialLeaguesState = LeaguesListState(leagues: .initial)
