//
//  CacheTimes.swift
//  ReFoot
//
//  Created by merengue on 29/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import RealmSwift

final class CacheTimes: Object {
    @objc dynamic var leaguesList: Double = 0.0
}

private let dayInMillis: Double = 86400000.0

func cacheLimit(forObjectOfType type: Object.Type) -> Double {
    switch type {
    case _ as PersistableLeague.Type:
        return dayInMillis
    default:
        return Double.greatestFiniteMagnitude
    }
}

func isCacheTimeValid(_ cacheTimeMillis: Double, against limitMillis: Double) -> Bool {
    return Date().timeIntervalSince1970 - cacheTimeMillis < limitMillis
}

struct InvalidCacheError: Swift.Error {}
