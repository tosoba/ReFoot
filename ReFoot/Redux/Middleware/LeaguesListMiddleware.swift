//
//  LeaguesListMiddleware.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

typealias LeaguesListMiddleware = SimpleMiddleware<AppState>

func leaguesListMiddleware(repository: FootballRepository) -> LeaguesListMiddleware {
    return { fetchLeagues(action: $0, context: $1, repository: repository) }
}

private func fetchLeagues(action: Action, context: MiddlewareContext<AppState>, repository: FootballRepository) -> Action? {
    guard let fetchLeaguesList = action as? LeaguesListAction, case .fetch = fetchLeaguesList else { return action }
    
    repository.getLeagues({leagues in }, onError: {})
    
    return nil
}
