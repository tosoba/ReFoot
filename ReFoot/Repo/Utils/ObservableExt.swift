//
//  ObservableExt.swift
//  ReFoot
//
//  Created by merengue on 20/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import RxSwift
import ObjectMapper

extension Observable {
    func subscribe(thenOnSuccess onSuccess: @escaping (Element) -> Void, orOnError onError: @escaping (Error) -> Void, laterDisposeUsing bag: DisposeBag) {
        subscribe { event in
            switch event {
            case .next(let result): onSuccess(result)
            case .error(let error): onError(error)
            default: break
            }
        }
        .disposed(by: bag)
    }
    
    func subscribeOnBackgroundAndObserveOnMainThread() -> Observable<Element> {
        return subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    func subscribeOnBackgroundAndObserveOnMainThread(thenOnSuccess onSuccess: @escaping (Element) -> Void, orOnError onError: @escaping (Error) -> Void, laterDisposeUsing bag: DisposeBag) {
        subscribeOnBackgroundAndObserveOnMainThread()
            .subscribe(thenOnSuccess: onSuccess, orOnError: onError, laterDisposeUsing: bag)
    }
}

extension Observable where Element == Any {
    func mapResultToArrayOfImmutables<T>(usingDataFromJSONPropertyCalled propertyName: String) -> Observable<[T]> where T: ImmutableMappable {
        return map {
            let json = $0 as! [String : Any]
            let propetyJSONValue = json[propertyName] as! [[String: Any]]
            return propetyJSONValue.map { (jsonObject: [String: Any]) -> T in
                let map = Map(mappingType: .fromJSON, JSON: jsonObject)
                return try! T.init(map: map)
            }
        }
    }
}
