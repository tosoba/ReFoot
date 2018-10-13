//
//  LeagueTeamsMiddleware.swift
//  ReFoot
//
//  Created by merengue on 07/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func leagueTeamsMiddleware(using repository: FootballRepository) -> SimpleMiddleware<AppState> {
    return { fetchLeagueTeams(action: $0, context: $1, repository: repository) }
}

private func fetchLeagueTeams(action: Action, context: MiddlewareContext<AppState>, repository: FootballRepository) -> Action? {
    guard let fetchLeagueTeamsAction = action as? LeagueTeamsAction, case .fetch(let league) = fetchLeagueTeamsAction else {
        return action
    }
    
    context.dispatch(LeagueTeamsAction.set(.loading, league))
    
    repository.getTeams(in: league, thenOnSuccess: { leagueTeams in
        context.dispatch(LeagueTeamsAction.set(.value(EquatableArray(data: leagueTeams)), league))
    }, orOnError: { error in
        context.dispatch(LeagueTeamsAction.set(.error(error), league))
    })
    
    return nil
}
