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

protocol RemoteFootballDataStore {
     func getLeagues(_ onSuccess: ([League]) -> Void, onError: () -> Void)
}

final class RemoteFootballDataStoreImpl : RemoteFootballDataStore {
    
    private let disposeBag = DisposeBag()
    
    func getLeagues(_ onSuccess: ([League]) -> Void, onError: () -> Void) {
        URLSession.shared.rx
            .json(url: URLs.allLeagues)
            .observeOn(MainScheduler.instance)
            .subscribe {
                print($0)
            }
            .disposed(by: disposeBag)
    }
}

struct URLs {
    private static let base = "https://www.thesportsdb.com/api/v1/json/1/"
    
    static let allLeagues = URL(string: "\(base)search_all_leagues.php?s=Soccer")!
}
