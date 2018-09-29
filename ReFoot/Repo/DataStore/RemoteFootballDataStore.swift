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
}

final class RemoteFootballDataStoreImpl : RemoteFootballDataStore {
    
    var leagues: Observable<[League]> {
        return URLSession.shared.rx
            .json(url: URLs.allLeagues)
            .map { (result: Any) -> [League] in
                let json = result as! [String : Any]
                let leaguesJSON = json["countrys"] as! [[String: Any]]
                return leaguesJSON.map { leagueJson in
                    let map = Map(mappingType: .fromJSON, JSON: leagueJson)
                    return try! League(map: map)
            }
        }
    }
}

struct URLs {
    private static let base = "https://www.thesportsdb.com/api/v1/json/1/"
    
    static let allLeagues = URL(string: "\(base)search_all_leagues.php?s=Soccer")!
}
