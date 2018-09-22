//
//  UIViewControllerExt.swift
//  ReFoot
//
//  Created by merengue on 22/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func add(childViewController viewController: UIViewController, to view: UIView) {
        addChildViewController(viewController)
        
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParentViewController: self)
    }
    
    func remove(childViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        
        viewController.view.removeFromSuperview()
        
        viewController.removeFromParentViewController()
    }
    
    func show(
        childViewController viewController: UIViewController,
        in containerView: UIView,
        updating currentChildViewController: inout UIViewController?
    ) {
        if let currentChild = currentChildViewController {
            remove(childViewController: currentChild)
        }
        add(childViewController: viewController, to: containerView)
        currentChildViewController = viewController
    }
}

func instantiateViewController<T>(
    withIdentifier identifier: String,
    from storyboard: UIStoryboard
) -> T where T : UIViewController {
    return storyboard.instantiateViewController(withIdentifier: identifier) as! T
}
