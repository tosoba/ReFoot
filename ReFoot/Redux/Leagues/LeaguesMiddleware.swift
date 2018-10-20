//
//  LeaguesListMiddleware.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func leaguesMiddleware(using repository: FootballRepository) -> SimpleMiddleware<AppState> {
    return { leaguesMiddlewareFunc(action: $0, context: $1, repository: repository) }
}

private func leaguesMiddlewareFunc(action: Action, context: MiddlewareContext<AppState>, repository: FootballRepository) -> Action? {
    guard let leaguesAction = action as? LeaguesAction else { return action }
    
    switch leaguesAction {
    case .fetchLeagues:
        context.dispatch(LeaguesAction.setLeagues(.loading))
        
        repository.getLeagues(thenOnSuccess: { leagues in
            context.dispatch(LeaguesAction.setLeagues(.value(EquatableArray(data: leagues))))
        }, orOnError: { error in
            context.dispatch(LeaguesAction.setLeagues(.error(error)))
        })
    case .selectLeague(let league):
        if context.state?.leaguesState.areTeamsLoaded(for: league) == true {
            return action
        }
        
        context.dispatch(LeaguesAction.fetchTeams(league))
        return action
    case .fetchTeams(let league):
        context.dispatch(LeaguesAction.setTeamsForLeague(.loading, league))
        
        repository.getTeams(in: league, thenOnSuccess: { teams in
            context.dispatch(LeaguesAction.setTeamsForLeague(.value(EquatableArray(data: teams)), league))
        }, orOnError: { error in
            context.dispatch(LeaguesAction.setTeamsForLeague(.error(error), league))
        })
    default:
        return action
    }
    
    return nil
}
