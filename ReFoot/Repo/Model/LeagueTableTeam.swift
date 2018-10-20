//
//  LeagueTableTeam.swift
//  ReFoot
//
//  Created by merengue on 20/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import ObjectMapper
import RxDataSources

struct LeagueTableTeam: ImmutableMappable {
    let name: String
    let teamId: String
    let gamesPlayed: Int
    let goalsScored: Int
    let goalsConceded: Int
    let wins: Int
    let draws: Int
    let losses: Int
    let points: Int
    
    init(map: Map) throws {
        name = (try? map.value("name")) ?? Placeholder.unknown
        teamId = (try? map.value("teamid")) ?? Placeholder.nullId
        gamesPlayed = (try? map.value("played")) ?? Placeholder.unknownNumber
        goalsScored = (try? map.value("goalsfor")) ?? Placeholder.unknownNumber
        goalsConceded = (try? map.value("goalsagainst")) ?? Placeholder.unknownNumber
        wins = (try? map.value("win")) ?? Placeholder.unknownNumber
        draws = (try? map.value("draw")) ?? Placeholder.unknownNumber
        losses = (try? map.value("loss")) ?? Placeholder.unknownNumber
        points = (try? map.value("total")) ?? Placeholder.unknownNumber
    }
}

extension LeagueTableTeam: Equatable {
    static func ==(lhs: LeagueTableTeam, rhs: LeagueTableTeam) -> Bool {
        return lhs.teamId == rhs.teamId
    }
}

extension LeagueTableTeam: IdentifiableType {
    public typealias Identity = String
    
    var identity: String { return teamId }
}
