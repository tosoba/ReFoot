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
    
    func loadingViewController(withTitle title: String, andMessage message: String? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(frame: alert.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        alert.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        return alert
    }
}
