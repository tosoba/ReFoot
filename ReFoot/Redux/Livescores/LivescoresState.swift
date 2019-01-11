//
//  LivescoresState.swift
//  ReFoot
//
//  Created by merengue on 11/01/2019.
//  Copyright © 2019 merengue. All rights reserved.
//

import ReSwift

struct LivescoresState: StateType {
    var livescores: Loadable<EquatableArray<LiveMatchEvent>>
}

let initialLivescoreState = LivescoresState(livescores: .initial)
