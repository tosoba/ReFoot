//
//  MatchEvent.swift
//  ReFoot
//
//  Created by merengue on 06/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources
import RealmSwift

struct MatchEvent: ImmutableMappable {
    let id: String
    let labelShort: String
    let labelFull: String
    let leagueId: String
    let leagueName: String
    let homeTeamName: String
    let awayTeamName: String
    let round: String
    let homeScore: String
    let awayScore: String
    let date: String
    let time: String
    let homeTeamId: String
    let awayTeamId: String
    
    init(map: Map) throws {
        id = (try? map.value("idEvent")) ?? nullId
        labelShort = (try? map.value("strEvent")) ?? unknown
        labelFull = (try? map.value("strFilename")) ?? unknown
        leagueId = (try? map.value("idLeague")) ?? nullId
        leagueName = (try? map.value("strLeague")) ?? unknown
        homeTeamName = (try? map.value("strHomeTeam")) ?? unknown
        awayTeamName = (try? map.value("strAwayTeam")) ?? unknown
        round = (try? map.value("intRound")) ?? unknown
        homeScore = (try? map.value("intHomeScore")) ?? unknownScore
        awayScore =  (try? map.value("intAwayScore")) ?? unknownScore
        date = (try? map.value("dateEvent")) ?? unknown
        time = (try? map.value("strTime")) ?? unknown
        homeTeamId = (try? map.value("idHomeTeam")) ?? nullId
        awayTeamId = (try? map.value("idAwayTeam")) ?? nullId
    }
}

extension MatchEvent: Equatable {
    static func ==(lhs: MatchEvent, rhs: MatchEvent) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MatchEvent: IdentifiableType {
    typealias Identity = String
    
    var identity: String { return id }
}

extension MatchEvent: Persistable {
    typealias ManagedObject = PersistableMatchEvent
    
    init(managedObject: ManagedObject) {
        id = managedObject.id
        labelShort = managedObject.labelShort
        labelFull = managedObject.labelFull
        leagueId = managedObject.leagueId
        leagueName = managedObject.leagueName
        homeTeamName = managedObject.homeTeamName
        awayTeamName = managedObject.awayTeamName
        round = managedObject.round
        homeScore = managedObject.homeScore
        awayScore = managedObject.awayScore
        date = managedObject.date
        time = managedObject.time
        homeTeamId = managedObject.homeTeamId
        awayTeamId = managedObject.awayTeamId
    }
    
    func managedObject() -> PersistableMatchEvent {
        let persistable = PersistableMatchEvent()
        persistable.id = id
        persistable.labelShort = labelShort
        persistable.labelFull = labelFull
        persistable.leagueId = leagueId
        persistable.leagueName = leagueName
        persistable.homeTeamName = homeTeamName
        persistable.awayTeamName = awayTeamName
        persistable.round = round
        persistable.homeScore = homeScore
        persistable.awayScore = awayScore
        persistable.date = date
        persistable.time = time
        persistable.homeTeamId = homeTeamId
        persistable.awayTeamId = awayTeamId
        return persistable
    }
}

final class PersistableMatchEvent: Object {
    @objc dynamic var id = ""
    @objc dynamic var labelShort = ""
    @objc dynamic var labelFull = ""
    @objc dynamic var leagueId = ""
    @objc dynamic var leagueName = ""
    @objc dynamic var homeTeamName = ""
    @objc dynamic var awayTeamName = ""
    @objc dynamic var round = ""
    @objc dynamic var homeScore = ""
    @objc dynamic var awayScore = ""
    @objc dynamic var date = ""
    @objc dynamic var time = ""
    @objc dynamic var homeTeamId = ""
    @objc dynamic var awayTeamId = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
