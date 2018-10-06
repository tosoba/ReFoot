//
//  ScoresHostReducer.swift
//  ReFoot
//
//  Created by merengue on 06/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func scoresHostReducer(action: Action, state: ScoresHostState?) -> ScoresHostState {
    var currentState = state ?? initialScoresHostState
    guard let scoresHostAction = action as? ScoresHostAction else {
        return currentState
    }
    
    switch scoresHostAction {
    case .set(let date):
        currentState.date = date
    }
    
    return currentState
}
