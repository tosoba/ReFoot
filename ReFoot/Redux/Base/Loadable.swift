//
//  Loadable.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation

enum Loadable<T> {
    case initial
    case loading
    case value(T)
    case error(Error)
}
