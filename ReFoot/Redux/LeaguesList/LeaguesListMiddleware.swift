//
//  LeaguesListMiddleware.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func leaguesListMiddleware(using repository: FootballRepository) -> SimpleMiddleware<AppState> {
    return { fetchLeagues(action: $0, context: $1, repository: repository) }
}

private func fetchLeagues(action: Action, context: MiddlewareContext<AppState>, repository: FootballRepository) -> Action? {
    guard let fetchLeaguesListAction = action as? LeaguesListAction else { return action }
    
    switch fetchLeaguesListAction {
    case .fetch:
        context.dispatch(LeaguesListAction.set(Loadable.loading))
        
        repository.getLeagues(thenOnSuccess: { leagues in
            context.dispatch(LeaguesListAction.set(Loadable.value(EquatableArray(data: leagues))))
        }, orOnError: { error in
            context.dispatch(LeaguesListAction.set(Loadable.error(error)))
        })
    case .selectLeague(let league):
        if context.state?.leagueTeamsState.areTeamsLoaded(for: league) == true {
            return action
        }
        context.dispatch(LeagueTeamsAction.fetch(league))
        return action
    default:
        return action
    }
    
    return nil
}
