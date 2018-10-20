//
//  LeaguesListMiddleware.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

func leaguesMiddleware(using repository: FootballRepository) -> SimpleMiddleware<AppState> {
    return { (action, context) in
        handleLeaguesAction(action, in: context, using: repository)
    }
}

private func handleLeaguesAction(_ action: Action, in context: MiddlewareContext<AppState>, using repository: FootballRepository) -> Action? {
    guard let leaguesAction = action as? LeaguesAction else { return action }
    
    switch leaguesAction {
    case .fetchLeagues:
        context.dispatch(LeaguesAction.setLeagues(.loading))
        
        repository.getLeagues(thenOnSuccess: { leagues in
            context.dispatch(LeaguesAction.setLeagues(.value(EquatableArray(data: leagues))))
        }, orOnError: {
            context.dispatch(LeaguesAction.setLeagues(.error($0)))
        })
    case .selectLeague(let league):
        if context.state?.leaguesState.areTeamsLoaded(for: league) == false {
            context.dispatch(LeaguesAction.fetchTeams(league))
        }
        
        if context.state?.leaguesState.isTableLoaded(for: league) == false {
            context.dispatch(LeaguesAction.fetchTable(league))
        }
        
        return action
    case .fetchTeams(let league):
        context.dispatch(LeaguesAction.setTeamsForLeague(.loading, league))
        
        repository.getTeams(in: league, thenOnSuccess: { teams in
            context.dispatch(LeaguesAction.setTeamsForLeague(.value(EquatableArray(data: teams)), league))
        }, orOnError: {
            context.dispatch(LeaguesAction.setTeamsForLeague(.error($0), league))
        })
    case .fetchTable(let league):
        context.dispatch(LeaguesAction.setTableForLeague(.loading, league))
        
        repository.getTable(for: league, thenOnSuccess: { tableTeams in
            context.dispatch(LeaguesAction.setTableForLeague(.value(EquatableArray(data: tableTeams)), league))
        }, orOnError: {
            context.dispatch(LeaguesAction.setTableForLeague(.error($0), league))
        })
    default:
        return action
    }
    
    return nil
}
