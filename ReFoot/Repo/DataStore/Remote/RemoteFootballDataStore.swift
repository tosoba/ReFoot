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
     func getLeagues(thenOnSuccess onSuccess: @escaping ([League]) -> Void, orOnError onError: @escaping (Error) -> Void)
}

final class RemoteFootballDataStoreImpl : RemoteFootballDataStore {
    
    private let disposeBag = DisposeBag()
    
    func getLeagues(thenOnSuccess onSuccess: @escaping ([League]) -> Void, orOnError onError: @escaping (Error) -> Void) {
        URLSession.shared.rx
            .json(url: URLs.allLeagues)
            .observeOn(MainScheduler.instance)
            .subscribe { event in
                switch event {
                case .next:
                    guard let json = event.element as? [String: Any], let leaguesJson = json["countrys"] as? [[String: Any]] else { return }
                    let leagues: [League] = leaguesJson.map { leagueJson in
                        let map = Map(mappingType: .fromJSON, JSON: leagueJson)
                        return try! League(map: map)
                    }
                    onSuccess(leagues)
                case .error(let error):
                    onError(error)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

struct URLs {
    private static let base = "https://www.thesportsdb.com/api/v1/json/1/"
    
    static let allLeagues = URL(string: "\(base)search_all_leagues.php?s=Soccer")!
}
