//
//  DayEventsTableViewSection.swift
//  ReFoot
//
//  Created by merengue on 06/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxDataSources

struct DayEventsTableViewSection {
    var title: String
    var events: [MatchEvent]
}

extension DayEventsTableViewSection : IdentifiableType {
    public typealias Identity = String
    
    var identity: String { return title }
}

extension DayEventsTableViewSection: AnimatableSectionModelType {
    var items: [MatchEvent] {
        return events
    }
    
    typealias Item = MatchEvent
    
    init(original: DayEventsTableViewSection, items: [Item]) {
        self = original
        self.events = items
    }
}
