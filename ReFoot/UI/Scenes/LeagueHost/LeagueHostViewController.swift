//
//  LeagueHostViewController.swift
//  ReFoot
//
//  Created by merengue on 22/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LeagueHostViewController: UIViewController {

    @IBOutlet weak var leagueChildSegmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    private let disposeBag = DisposeBag()
    
    private lazy var leagueTableViewController: LeagueTableViewController = instantiateViewController(withIdentifier: LeagueTableViewController.identifier, fromSwinjectStoryboardNamed: "LeagueTable")
    
    private lazy var leagueTeamsViewController: LeagueTeamsViewController = instantiateViewController(withIdentifier: LeagueTeamsViewController.identifier, fromSwinjectStoryboardNamed: "LeagueTeams")
    
    private lazy var leagueInfoViewController: LeagueInfoViewController = instantiateViewController(withIdentifier: LeagueInfoViewController.identifier, fromSwinjectStoryboardNamed: "LeagueInfo")
    
    private var currentChildViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        leagueChildSegmentedControl.rx.value
            .distinctUntilChanged()
            .subscribe { [weak self] event in
                guard case let .next(index) = event, let this = self else { return }
                this.childSelectionDidChange(toIndex: index)
            }
            .disposed(by: disposeBag)
    }
    
    private func childSelectionDidChange(toIndex index: Int) {
        switch index {
        case 0:
            show(childViewController: leagueTableViewController, in: containerView, updating: &self.currentChildViewController)
        case 1:
            show(childViewController: leagueTeamsViewController, in: containerView, updating: &self.currentChildViewController)
        case 2:
            show(childViewController: leagueInfoViewController, in: containerView, updating: &self.currentChildViewController)
        default:
            return
        }
    }
}
