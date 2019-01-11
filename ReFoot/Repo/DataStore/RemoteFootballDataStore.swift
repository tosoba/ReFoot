//
//  RemoteFootballDataStore.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift
import ObjectMapper

protocol RemoteFootballDataStore {
    var leagues: Observable<[League]> { get }
    func matchEvents(on date: Date) -> Observable<[MatchEvent]>
    func teams(in league: League) -> Observable<[Team]>
    func leagueTable(for league: League) -> Observable<[LeagueTableTeam]>
    var liveMatchEvents: Observable<[LiveMatchEvent]> { get }
}

final class RemoteFootballDataStoreImpl : RemoteFootballDataStore {
    
    var leagues: Observable<[League]> {
        return callEndpoint(identifiedBy: URLFor.allLeagues)
            .mapResultToArrayOfImmutables(usingDataFromJSONPropertyCalled: "countrys")
    }
    
    var liveMatchEvents: Observable<[LiveMatchEvent]> {
        return callEndpoint(identifiedBy: URLFor.liveMatchEvents).map {
            let json = $0 as! [String : Any]
            return json["teams"] as! [String: Any]
        }.mapResultToArrayOfImmutables(usingDataFromJSONPropertyCalled: "Match")
    }
    
    func matchEvents(on date: Date) -> Observable<[MatchEvent]> {
        return callEndpoint(identifiedBy: URLFor.matchEvents(on: date.toStringYearMonthDay()))
            .mapResultToArrayOfImmutables(usingDataFromJSONPropertyCalled: "events")
    }
    
    func teams(in league: League) -> Observable<[Team]> {
        return callEndpoint(identifiedBy: URLFor.teams(inLeagueNamed: league.name))
            .mapResultToArrayOfImmutables(usingDataFromJSONPropertyCalled: "teams")
    }
    
    func leagueTable(for league: League) -> Observable<[LeagueTableTeam]> {
        return callEndpoint(identifiedBy: URLFor.table(ofLeagueWithId: league.id))
            .mapResultToArrayOfImmutables(usingDataFromJSONPropertyCalled: "table")
    }
    
    private func callEndpoint(identifiedBy url: URL) -> Observable<Any> {
        return URLSession.shared.rx.json(url: url)
    }
}

struct URLFor {
    private static let base = "https://www.thesportsdb.com/api/v1/json/1/"
    
    static let allLeagues = URL(string: "\(base)search_all_leagues.php?s=Soccer")!
    
    static let liveMatchEvents = URL(string: "\(base)latestsoccer.php")!
    
    static func matchEvents(on dateStr: String) -> URL {
        return URL(string: "\(base)eventsday.php?d=\(dateStr)&s=Soccer")!
    }
    
    static func teams(inLeagueNamed name: String) -> URL {
        return URL(string: "\(base)search_all_teams.php?l=\(name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")!
    }
    
    static func table(ofLeagueWithId id: String) -> URL {
        return URL(string: "\(base)lookuptable.php?l=\(id)")!
    }
}
