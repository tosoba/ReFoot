//
//  League.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources
import RealmSwift

struct League: ImmutableMappable {
    let id: String
    let name: String
    let country: String?
    let websiteURL: String?
    let facebookURL: String?
    let twitterURL: String?
    let description: String
    let fanarts: [String]
    let banner: String?
    let badge: String?
    let logo: String?
    let poster: String?
    let trophy: String?
    
    init(map: Map) throws {
        id = (try? map.value("idLeague")) ?? Placeholder.nullId
        name = (try? map.value("strLeague")) ?? Placeholder.unknown
        country = try? map.value("strCountry")
        websiteURL = try? map.value("strWebsite")
        facebookURL = try? map.value("strFacebook")
        twitterURL = try? map.value("strTwitter")
        description = (try? map.value("strDescriptionEN")) ?? ""
        
        let fanart1: String? = try? map.value("strFanart1")
        let fanart2: String? = try? map.value("strFanart2")
        let fanart3: String? = try? map.value("strFanart3")
        let fanart4: String? = try? map.value("strFanart4")
        fanarts = [fanart1, fanart2, fanart3, fanart4,].filter { $0 != nil }.map { $0! }
        
        banner = try? map.value("strBanner")
        badge = try? map.value("strBadge")
        logo = try? map.value("strLogo")
        poster = try? map.value("strPoster")
        trophy = try? map.value("strTrophy")
    }
}

extension League: Equatable {
    static func ==(lhs: League, rhs: League) -> Bool {
        return lhs.id == rhs.id
    }
}

extension League: IdentifiableType {
    typealias Identity = String
    
    var identity: String { return id }
}

extension League: Persistable {
    typealias ManagedObject = PersistableLeague
    
    init(managedObject: ManagedObject) {
        id = managedObject.id
        name = managedObject.name
        country = managedObject.country
        websiteURL = managedObject.websiteURL
        facebookURL = managedObject.facebookURL
        twitterURL = managedObject.twitterURL
        description = managedObject.description
        fanarts = Array(managedObject.fanarts)
        banner = managedObject.banner
        badge = managedObject.badge
        logo = managedObject.logo
        poster = managedObject.poster
        trophy = managedObject.trophy
    }
    
    func managedObject() -> ManagedObject {
        let persistable = PersistableLeague()
        persistable.id = id
        persistable.name = name
        persistable.country = country
        persistable.websiteURL = websiteURL
        persistable.facebookURL = facebookURL
        persistable.twitterURL = twitterURL
        persistable.leagueDescription = description
        persistable.fanarts.append(objectsIn: fanarts)
        persistable.banner = banner
        persistable.badge = badge
        persistable.logo = logo
        persistable.poster = poster
        persistable.trophy = trophy
        return persistable
    }
}

final class PersistableLeague: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var country: String? = nil
    @objc dynamic var websiteURL: String? = nil
    @objc dynamic var facebookURL: String? = nil
    @objc dynamic var twitterURL: String? = nil
    @objc dynamic var leagueDescription = ""
    var fanarts = List<String>()
    @objc dynamic var banner: String? = nil
    @objc dynamic var badge: String? = nil
    @objc dynamic var logo: String? = nil
    @objc dynamic var poster: String? = nil
    @objc dynamic var trophy: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
