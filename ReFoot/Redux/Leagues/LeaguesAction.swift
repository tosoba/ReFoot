//
//  LeaguesAction.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ReSwift

enum LeaguesAction: Action {
    case fetchLeagues
    case setLeagues(Loadable<EquatableArray<League>>)
    
    case selectLeague(League)
    
    case fetchTeams(League)
    case setTeamsForLeague(Loadable<EquatableArray<Team>>, League)
    
    case fetchTable(League)
    case setTableForLeague(Loadable<EquatableArray<LeagueTableTeam>>, League)
}
