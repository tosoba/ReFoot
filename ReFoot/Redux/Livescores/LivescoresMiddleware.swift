//
//  LivescoresMiddleware.swift
//  ReFoot
//
//  Created by merengue on 11/01/2019.
//  Copyright © 2019 merengue. All rights reserved.
//

import ReSwift

func livescoresMiddleware(using repository: FootballRepository) -> SimpleMiddleware<AppState> {
    return { (action, context) in
        handleLivescoresAction(action, in: context, using: repository)
    }
}

private func handleLivescoresAction(_ action: Action, in context: MiddlewareContext<AppState>, using repository: FootballRepository) -> Action? {
    guard let fetchLivescoresAction = action as? LivescoresAction, case .fetch = fetchLivescoresAction else { return action }
    
    if context.state?.livescoresState.livescores.isValueSet == true {
        return action
    }
    
    context.dispatch(LivescoresAction.set(.loading))
    
    repository.getLiveMatchEvents(thenOnSuccess: { liveEvents in
        context.dispatch(LivescoresAction.set(.value(EquatableArray(data: liveEvents))))
    }, orOnError: { error in
        context.dispatch(LivescoresAction.set(.error(error)))
    })
    
    return nil
}
