//
//  LivescoresReducer.swift
//  ReFoot
//
//  Created by merengue on 11/01/2019.
//  Copyright © 2019 merengue. All rights reserved.
//

import ReSwift

func livescoresReducer(action: Action, state: LivescoresState?) -> LivescoresState {
    var currentState = state ?? initialLivescoreState
    guard let livescoresAction = action as? LivescoresAction else {
        return currentState
    }
    
    switch livescoresAction {
    case .set(let loadable):
        currentState.livescores = loadable
    default:
        break
    }
    
    return currentState
}
