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
}

final class RemoteFootballDataStoreImpl : RemoteFootballDataStore {
    
    var leagues: Observable<[League]> {
        return URLSession.shared.rx
            .json(url: URLFor.allLeagues)
            .map { (result: Any) -> [League] in
                let json = result as! [String : Any]
                let leaguesJSON = json["countrys"] as! [[String: Any]]
                return leaguesJSON.map { leagueJson in
                    let map = Map(mappingType: .fromJSON, JSON: leagueJson)
                    return try! League(map: map)
            }
        }
    }
    
    func matchEvents(on date: Date) -> Observable<[MatchEvent]> {
        return URLSession.shared.rx
            .json(url: URLFor.matchEvents(on: date.toStringYearMonthDay()))
            .map { (result: Any) -> [MatchEvent] in
                let json = result as! [String : Any]
                let eventsJSON = json["events"] as! [[String: Any]]
                return eventsJSON.map { eventJson in
                    let map = Map(mappingType: .fromJSON, JSON: eventJson)
                    return try! MatchEvent(map: map)
            }
        }
    }
}

struct URLFor {
    private static let base = "https://www.thesportsdb.com/api/v1/json/1/"
    
    static let allLeagues = URL(string: "\(base)search_all_leagues.php?s=Soccer")!
    
    static func matchEvents(on dateStr: String) -> URL {
        return URL(string: "\(base)eventsday.php?d=\(dateStr)&s=Soccer")!
    }
}
