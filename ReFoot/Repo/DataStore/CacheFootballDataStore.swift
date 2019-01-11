//
//  CacheFootballDataStore.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import RxSwift
import RealmSwift
import RxRealm

protocol CacheFootballDataStore {
    var leagues: Observable<[League]> { get }
    func saveLeagues(_ leagues: [League]) -> Completable
    var liveMatchEvents: Observable<[LiveMatchEvent]> { get }
    func saveLiveMatchEvents(_ events: [LiveMatchEvent]) -> Completable
}

final class CacheFootballDataStoreImpl : CacheFootballDataStore {
    
    init() {
        setupCacheTimes()
    }
    
    private func setupCacheTimes() {
        if realm.isEmpty {
            try! realm.write {
                realm.add(CacheTimes())
            }
        }
    }
    
    var leagues: Observable<[League]> {
        return getCachedItems(limitedBy: savedCacheTimesObservable.map { $0.leaguesList })
    }
    
    func saveLeagues(_ leagues: [League]) -> Completable {
        return saveItemsByDeletingPreviouslySaved(leagues, andUpdatingCacheTimeWith: { $0.leaguesList = Date().timeIntervalSince1970 })
    }
    
    var liveMatchEvents: Observable<[LiveMatchEvent]> {
        return getCachedItems(limitedBy: savedCacheTimesObservable.map { $0.liveMatchEvents })
    }
    
    func saveLiveMatchEvents(_ events: [LiveMatchEvent]) -> Completable {
        return saveItemsByDeletingPreviouslySaved(events, andUpdatingCacheTimeWith: { $0.liveMatchEvents = Date().timeIntervalSince1970 })
    }
    
    private var savedCacheTimesObservable: Observable<CacheTimes> {
         return Observable.just(realm.objects(CacheTimes.self).first!)
    }
    
    private func getCachedItems<P: Persistable>(limitedBy cacheLimitTime: Observable<Double>) -> Observable<[P]> {
        return cacheLimitTime.map { isCacheTimeValid($0, against: cacheLimit(forObjectOfType: P.ManagedObject.self)) }
            .flatMap { (isValid: Bool) -> Observable<[P]> in
                if isValid {
                    return Observable.array(from: realm.objects(P.ManagedObject.self))
                        .map { return $0.map { P.init(managedObject: $0) } }
                } else {
                    return Observable<[P]>.error(InvalidCacheError())
                }
        }
    }
    
    private func deleteAllItems(ofType type: Object.Type) -> Completable {
        return realm.writeCompletable {
            realm.delete(realm.objects(type))
        }
    }
    
    private func updateCache(_ update: @escaping (CacheTimes) -> Void) -> Completable {
        return realm.writeCompletable {
            update(realm.objects(CacheTimes.self).first!)
        }
    }
    
    private func saveItemsByDeletingPreviouslySaved<P: Persistable>(_ items: [P], andUpdatingCacheTimeWith update: @escaping (CacheTimes) -> Void) -> Completable {
        return deleteAllItems(ofType: P.ManagedObject.self).andThen(Completable.deferred { [unowned self] in
            try! realm.write {
                realm.add(items.map { $0.managedObject() })
            }
            return self.updateCache(update)
        })
    }
}
