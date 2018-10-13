//
//  Team.swift
//  ReFoot
//
//  Created by merengue on 07/10/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import ObjectMapper
import RxDataSources

struct Team: ImmutableMappable {
    let id: String
    let name: String
    let leagueName: String
    let leagueId: String
    let managerName: String
    let stadiumName: String
    let stadiumThumbnailURL: String?
    let stadiumDescription: String
    let stadiumLocation: String
    let stadiumCapacity: String
    let websiteURL: String?
    let facebookURL: String? //TODO: facebook/twitter URLs are sometimes empty instead of null
    let twitterURL: String?
    let instagramURL: String?
    let description: String
    let teamBadgeURL: String?
    let teamJerseyURL: String?
    let teamLogoURL: String?
    let fanarts: [String]
    let teamBannerURL: String?
    let youtubeURL: String?
    
    init(map: Map) throws {
        id = (try? map.value("idTeam")) ?? Placeholder.nullId
        name = (try? map.value("strTeam")) ?? Placeholder.unknown
        leagueName = (try? map.value("strLeague")) ?? Placeholder.unknown
        leagueId = (try? map.value("idLeague")) ?? Placeholder.nullId
        managerName = (try? map.value("strManager")) ?? Placeholder.unknown
        stadiumName = (try? map.value("strStadium")) ?? Placeholder.unknown
        stadiumThumbnailURL = try? map.value("strStadiumThumb")
        stadiumDescription = (try? map.value("strStadiumDescription")) ?? Placeholder.unknown
        stadiumLocation = (try? map.value("strStadiumLocation")) ?? Placeholder.unknown
        stadiumCapacity = (try? map.value("intStadiumCapacity")) ?? Placeholder.unknown
        websiteURL = try? map.value("strWebsite")
        facebookURL = try? map.value("strFacebook")
        twitterURL = try? map.value("strTwitter")
        instagramURL = try? map.value("strInstagram")
        description = (try? map.value("strDescriptionEN")) ?? Placeholder.unknown
        teamBadgeURL = try? map.value("strTeamBadge")
        teamJerseyURL = try? map.value("strTeamJersey")
        teamLogoURL = try? map.value("strTeamLogo")
        
        let fanart1: String? = try? map.value("strTeamFanart1")
        let fanart2: String? = try? map.value("strTeamFanart2")
        let fanart3: String? = try? map.value("strTeamFanart3")
        let fanart4: String? = try? map.value("strTeamFanart4")
        fanarts = [fanart1, fanart2, fanart3, fanart4,].filter { $0 != nil }.map { $0! }
        
        teamBannerURL = try? map.value("strTeamBanner")
        youtubeURL = try? map.value("strYoutube")
    }
}

extension Team: Equatable {
    static func ==(lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Team: IdentifiableType {
    public typealias Identity = String
    
    var identity: String { return id }
}
