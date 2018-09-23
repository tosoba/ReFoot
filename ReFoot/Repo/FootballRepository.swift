//
//  FootballRepository.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation

protocol FootballRepository {
    func getLeagues(thenOnSuccess onSuccess: @escaping ([League]) -> Void, orOnError onError: @escaping (Error) -> Void)
}

final class FootballRepositoryImpl : FootballRepository {
    
    let cache: CacheFootballDataStore
    let remote: RemoteFootballDataStore
    
    init(remote: RemoteFootballDataStore, cache: CacheFootballDataStore) {
        self.remote = remote
        self.cache = cache
    }
    
    func getLeagues(thenOnSuccess onSuccess: @escaping ([League]) -> Void, orOnError onError: @escaping (Error) -> Void) {
        remote.getLeagues(thenOnSuccess: onSuccess, orOnError: onError)
    }
}
