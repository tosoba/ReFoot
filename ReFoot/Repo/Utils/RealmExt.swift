//
//  RealmExt.swift
//  ReFoot
//
//  Created by merengue on 11/01/2019.
//  Copyright © 2019 merengue. All rights reserved.
//

import RealmSwift
import RxSwift

var realm: Realm {
    return try! Realm()
}

extension Realm {
    func writeCompletable(_ block: @escaping () -> Void) -> Completable {
        return Completable.deferred {
            try! realm.write { block() }
            return Completable.empty()
        }
    }
}
