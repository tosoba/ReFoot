//
//  League.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import ObjectMapper

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
        id = (try? map.value("idLeague")) ?? nullId
        name = (try? map.value("strLeague")) ?? placeholderName
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
