//
//  EquatableArray.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation

class EquatableArray<T: Equatable>: Equatable {
    
    let result: [T]
    
    init(result: [T]) {
        self.result = result
    }
    
    static func ==(lhs: EquatableArray<T>, rhs: EquatableArray<T>) -> Bool {
        return lhs == rhs
    }
}
