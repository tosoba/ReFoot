//
//  Loadable.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation

enum Loadable<T: Equatable>: Equatable {
    static func ==(lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (let .value(data1), let .value(data2)):
            return data1 == data2
        
        case (.loading, .loading):
            return true
            
        case (.initial, .initial):
            return true
            
        default:
            return false
        }
    }
    
    case initial
    case loading
    case value(T)
    case error(Error)
}
