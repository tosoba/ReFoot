//
//  LiveMatchEvent.swift
//  ReFoot
//
//  Created by merengue on 11/01/2019.
//  Copyright © 2019 merengue. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources
import RealmSwift

struct LiveMatchEvent: ImmutableMappable {
    let date: String
    let leagueName: String
    let round: String
    let homeTeamName: String
    let homeTeamId: String
    let awayTeamName: String
    let awayTeamId: String
    let time: String
    let homeScore: String
    let awayScore: String
    
    init(map: Map) throws {
        date = (try? map.value("Date")) ?? Placeholder.unknown
        leagueName = (try? map.value("League")) ?? Placeholder.unknown
        round = (try? map.value("Round")) ?? Placeholder.unknownNumberStr
        homeTeamName = (try? map.value("HomeTeam")) ?? Placeholder.unknown
        homeTeamId = (try? map.value("HomeTeam_Id")) ?? Placeholder.nullId
        awayTeamName = (try? map.value("AwayTeam")) ?? Placeholder.unknown
        awayTeamId = (try? map.value("AwayTeam_Id")) ?? Placeholder.nullId
        time = (try? map.value("Time")) ?? Placeholder.unknownNumberStr
        homeScore = (try? map.value("HomeGoals")) ?? Placeholder.unknownNumberStr
        awayScore = (try? map.value("AwayGoals")) ?? Placeholder.unknownNumberStr
    }
}

extension LiveMatchEvent: Equatable {
    static func ==(lhs: LiveMatchEvent, rhs: LiveMatchEvent) -> Bool {
        return lhs.homeTeamId == rhs.homeTeamId && lhs.awayTeamId == rhs.awayTeamId
    }
}

extension LiveMatchEvent: IdentifiableType {
    typealias Identity = String
    
    var identity: String { return homeTeamId + awayTeamId }
}

extension LiveMatchEvent: Persistable {
    typealias ManagedObject = PersistableLiveMatchEvent
    
    init(managedObject: ManagedObject) {
        date = managedObject.date
        leagueName = managedObject.leagueName
        round = managedObject.round
        homeTeamName = managedObject.homeTeamName
        homeTeamId = managedObject.homeTeamId
        awayTeamName = managedObject.awayTeamName
        awayTeamId = managedObject.awayTeamId
        time = managedObject.time
        homeScore = managedObject.homeScore
        awayScore = managedObject.awayScore
    }
    
    func managedObject() -> PersistableLiveMatchEvent {
        let persistable = PersistableLiveMatchEvent()
        persistable.id = homeTeamId + awayTeamId + date
        persistable.date = date
        persistable.leagueName = leagueName
        persistable.round = round
        persistable.homeTeamName = homeTeamName
        persistable.homeTeamId = homeTeamId
        persistable.awayTeamName = awayTeamName
        persistable.awayTeamId = awayTeamId
        persistable.time = time
        persistable.homeScore = homeScore
        persistable.awayScore = awayScore
        return persistable
    }
}

final class PersistableLiveMatchEvent: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = ""
    @objc dynamic var leagueName = ""
    @objc dynamic var round = ""
    @objc dynamic var homeTeamName = ""
    @objc dynamic var homeTeamId = ""
    @objc dynamic var awayTeamName = ""
    @objc dynamic var awayTeamId = ""
    @objc dynamic var time = ""
    @objc dynamic var homeScore = ""
    @objc dynamic var awayScore = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
