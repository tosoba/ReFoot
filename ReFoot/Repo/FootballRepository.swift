//
//  FootballRepository.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation

protocol FootballRepository {
    func getLeagues(_ onSuccess: ([League]) -> Void, onError: () -> Void)
}

final class FootballRepositoryImpl : FootballRepository {
    
    let cache: CacheFootballDataStore
    let remote: RemoteFootballDataStore
    
    init(remote: RemoteFootballDataStore, cache: CacheFootballDataStore) {
        self.remote = remote
        self.cache = cache
    }
    
    func getLeagues(_ onSuccess: ([League]) -> Void, onError: () -> Void) {
        remote.getLeagues(onSuccess, onError: onError)
    }
}
