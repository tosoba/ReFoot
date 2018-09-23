//
//  GlobalFuncs.swift
//  ReFoot
//
//  Created by merengue on 23/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import UIKit
import SwinjectStoryboard

func instantiateViewController<T>(
    withIdentifier identifier: String,
    from storyboard: UIStoryboard
) -> T where T : UIViewController {
    return storyboard.instantiateViewController(withIdentifier: identifier) as! T
}

func instantiateViewController<T>(
    withIdentifier identifier: String,
    fromStoryboardNamed name: String
) -> T where T : UIViewController {
    return SwinjectStoryboard.create(name: name, bundle: nil, container: appDelegate.dependenciesContainer).instantiateViewControllerWithIdentifier(identifier) as! T
}

var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}
