//
//  FootballRepository.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import RxSwift

protocol FootballRepository {
    func getLeagues(thenOnSuccess onSuccess: @escaping ([League]) -> Void, orOnError onError: @escaping (Error) -> Void)
    func getMatchEvents(on date: Date, thenOnSuccess onSuccess: @escaping ([MatchEvent]) -> Void, orOnError onError: @escaping (Error) -> Void)
    func getTeams(in league: League, thenOnSuccess onSuccess: @escaping ([Team]) -> Void, orOnError onError: @escaping (Error) -> Void)
    func getTable(for league: League, thenOnSuccess onSuccess: @escaping ([LeagueTableTeam]) -> Void, orOnError onError: @escaping (Error) -> Void)
}

final class FootballRepositoryImpl : FootballRepository {
    
    private let cache: CacheFootballDataStore
    private let remote: RemoteFootballDataStore
    
    private let disposeBag = DisposeBag()
    
    init(remote: RemoteFootballDataStore, cache: CacheFootballDataStore) {
        self.remote = remote
        self.cache = cache
    }
    
    func getLeagues(thenOnSuccess onSuccess: @escaping ([League]) -> Void, orOnError onError: @escaping (Error) -> Void) {
        let remoteLeagues = remote.leagues
            .observeOn(MainScheduler.instance)
            .flatMap { [unowned self] leagues in
                self.cache.saveLeagues(leagues)
                    .andThen(Observable.just(leagues))
            }
        
        cache.leagues
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { (cachedLeagues: [League]) -> Observable<[League]> in
                if cachedLeagues.isEmpty {
                    return remoteLeagues
                } else {
                    return Observable.just(cachedLeagues)
                }
            }
            .catchError { _ in remoteLeagues }
            .observeOn(MainScheduler.instance)
            .subscribe(thenOnSuccess: onSuccess, orOnError: onError, laterDisposeUsing: disposeBag)
    }
    
    func getMatchEvents(on date: Date, thenOnSuccess onSuccess: @escaping ([MatchEvent]) -> Void, orOnError onError: @escaping (Error) -> Void) {
        remote.matchEvents(on: date)
            .subscribeOnBackgroundAndObserveOnMainThread(thenOnSuccess: onSuccess, orOnError: onError, laterDisposeUsing: disposeBag)
    }
    
    func getTeams(in league: League, thenOnSuccess onSuccess: @escaping ([Team]) -> Void, orOnError onError: @escaping (Error) -> Void) {
        remote.teams(in: league)
            .subscribeOnBackgroundAndObserveOnMainThread(thenOnSuccess: onSuccess, orOnError: onError, laterDisposeUsing: disposeBag)
    }
    
    func getTable(for league: League, thenOnSuccess onSuccess: @escaping ([LeagueTableTeam]) -> Void, orOnError onError: @escaping (Error) -> Void) {
        remote.leagueTable(for: league)
            .subscribeOnBackgroundAndObserveOnMainThread(thenOnSuccess: onSuccess, orOnError: onError, laterDisposeUsing: disposeBag)
    }
}
