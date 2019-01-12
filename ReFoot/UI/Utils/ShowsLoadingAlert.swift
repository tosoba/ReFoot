//
//  ShowsLoadingAlert.swift
//  ReFoot
//
//  Created by merengue on 12/01/2019.
//  Copyright © 2019 merengue. All rights reserved.
//

import Foundation
import UIKit

protocol ShowsLoadingAlert: class {
    var loadingViewControllerShowing: Bool { get set }
    var loadingViewController: UIAlertController { get set }
    func showLoadingAlertIfNotShowing()
    func dismissLoadingAlertIfNotAlreadyDismissed()
}

extension ShowsLoadingAlert where Self: UIViewController {
    func showLoadingAlertIfNotShowing() {
        if !loadingViewControllerShowing {
            present(loadingViewController, animated: true, completion: nil)
            loadingViewControllerShowing = true
        }
    }
    
    func dismissLoadingAlertIfNotAlreadyDismissed() {
        if loadingViewControllerShowing {
            dismiss(animated: true, completion: nil)
            loadingViewControllerShowing = false
        }
    }
}
