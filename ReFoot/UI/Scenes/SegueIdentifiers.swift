//
//  SegueIdentifiers.swift
//  ReFoot
//
//  Created by merengue on 29/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import UIKit

func identifierForSegue(fromViewControllerOfType startVCType: UIViewController.Type, toViewControllerOfType destinationVCType: UIViewController.Type) -> String? {
    switch (startVCType, destinationVCType) {
    case (_, _) as (LeaguesListViewController.Type, LeagueHostViewController.Type):
        return "LeaguesListToLeagueHostSegue"
    default:
        return nil
    }
}
