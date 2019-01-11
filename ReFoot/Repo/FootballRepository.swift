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
    func getLiveMatchEvents(thenOnSuccess onSuccess: @escaping ([LiveMatchEvent]) -> Void, orOnError onError: @escaping (Error) -> Void)
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
        tryGetItemsFromCacheThenFromRemote(
            byGettingItemsFromCacheWith: { [unowned self] in return self.cache.leagues},
            andSavingWith: { [unowned self] items in return self.cache.saveLeagues(items) },
            orByUsingRemote: { [unowned self] in return self.remote.leagues },
            thenOnSuccess: onSuccess,
            orOnError: onError
        )
    }
    
    func getLiveMatchEvents(thenOnSuccess onSuccess: @escaping ([LiveMatchEvent]) -> Void, orOnError onError: @escaping (Error) -> Void) {
        tryGetItemsFromCacheThenFromRemote(
            byGettingItemsFromCacheWith: { [unowned self] in return self.cache.liveMatchEvents},
            andSavingWith: { [unowned self] items in return self.cache.saveLiveMatchEvents(items) },
            orByUsingRemote: { [unowned self] in return self.remote.liveMatchEvents },
            thenOnSuccess: onSuccess,
            orOnError: onError
        )
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
    
    private func tryGetItemsFromCacheThenFromRemote<T>(
        byGettingItemsFromCacheWith cacheGetBlock: @escaping () -> Observable<[T]>,
        andSavingWith cacheSaveBlock:  @escaping ([T]) -> Completable,
        orByUsingRemote remoteGetBlock: @escaping () -> Observable<[T]>,
        thenOnSuccess onSuccess: @escaping ([T]) -> Void,
        orOnError onError: @escaping (Error) -> Void) {
        
        let remoteItems = remoteGetBlock()
            .observeOn(MainScheduler.instance)
            .flatMap { items in
                cacheSaveBlock(items).andThen(Observable.just(items))
        }
        
        cacheGetBlock()
            .subscribeOn(MainScheduler.instance)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { (cachedItems: [T]) -> Observable<[T]> in
                if cachedItems.isEmpty {
                    return remoteItems
                } else {
                    return Observable.just(cachedItems)
                }
            }
            .catchError { _ in remoteItems }
            .observeOn(MainScheduler.instance)
            .subscribe(thenOnSuccess: onSuccess, orOnError: onError, laterDisposeUsing: disposeBag)
    }
    
}
