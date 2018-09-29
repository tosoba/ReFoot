//
//  EquatableArray.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation

final class EquatableArray<T: Equatable>: Equatable {
    
    let data: [T]
    
    init(data: [T]) {
        self.data = data
    }
    
    static func ==(lhs: EquatableArray<T>, rhs: EquatableArray<T>) -> Bool {
        return lhs.data == rhs.data
    }
}
