//
//  RxTableViewSection.swift
//  ReFoot
//
//  Created by merengue on 13/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import RxDataSources

struct RxTableViewAnimatableTitledSection<T : IdentifiableType & Equatable> {
    let title: String
    var sectionItems: [T]
    
    init(title: String, sectionItems: [T]) {
        self.title = title
        self.sectionItems = sectionItems
    }
}

extension RxTableViewAnimatableTitledSection: AnimatableSectionModelType {
    var items: [T] {
        return sectionItems
    }
    
    typealias Item = T
    
    init(original: RxTableViewAnimatableTitledSection, items: [Item]) {
        self = original
        self.sectionItems = items
    }
}

extension RxTableViewAnimatableTitledSection: IdentifiableType {
    typealias Identity = String
    
    var identity: String { return title }
}
