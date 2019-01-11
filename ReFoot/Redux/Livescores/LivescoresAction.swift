//
//  LivescoresAction.swift
//  ReFoot
//
//  Created by merengue on 11/01/2019.
//  Copyright © 2019 merengue. All rights reserved.
//

import ReSwift

enum LivescoresAction: Action {
    case fetch
    case set(Loadable<EquatableArray<LiveMatchEvent>>)
}
