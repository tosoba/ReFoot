//
//  LoadingState.swift
//  ReFoot
//
//  Created by merengue on 29/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case error(Error)
}
