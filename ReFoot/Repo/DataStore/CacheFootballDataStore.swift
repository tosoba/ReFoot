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
    
    private var leaguesListCacheTime: Observable<Double> {
        return Observable.just(realm.objects(CacheTimes.self).first!.leaguesList)
    }
    
    var leagues: Observable<[League]> {
        return leaguesListCacheTime.map { isCacheTimeValid($0, against: cacheLimit(forObjectOfType: PersistableLeague.self)) }
            .flatMap { (isValid: Bool) -> Observable<[League]> in
                if isValid {
                    return Observable.array(from: realm.objects(PersistableLeague.self))
                        .map { return $0.map { League.init(managedObject: $0) } }
                } else {
                    return Observable<[League]>.error(InvalidCacheError())
                }
        }
    }
    
    private var deleteAllLeagues: Completable {
        return Completable.deferred {
            try! realm.write {
                realm.delete(realm.objects(PersistableLeague.self))
            }
            return Completable.empty()
        }
    }
    
    private var updateLeaguesCache: Completable {
        return Completable.deferred {
            try! realm.write {
                realm.objects(CacheTimes.self).first!.leaguesList = Date().timeIntervalSince1970
            }
            return Completable.empty()
        }
    }
    
    func saveLeagues(_ leagues: [League]) -> Completable {
        return deleteAllLeagues.andThen(Completable.deferred { [unowned self] in
            try! realm.write {
                realm.add(leagues.map {$0.managedObject()})
            }
            return self.updateLeaguesCache
        })
    }
}

private var realm: Realm {
    return try! Realm()
}
