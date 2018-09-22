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
    
    private lazy var leagueTableViewController: LeagueTableViewController = instantiateViewController(withIdentifier: LeagueTableViewController.identifier, from: UIStoryboard(name: "LeagueTable", bundle: Bundle.main))
    
    private lazy var leagueTeamsViewController: LeagueTeamsViewController = instantiateViewController(withIdentifier: LeagueTeamsViewController.identifier, from: UIStoryboard(name: "LeagueTeams", bundle: Bundle.main))
    
    private lazy var leagueInfoViewController: LeagueInfoViewController = instantiateViewController(withIdentifier: LeagueInfoViewController.identifier, from: UIStoryboard(name: "LeagueInfo", bundle: Bundle.main))
    
    private var currentChildViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        leagueChildSegmentedControl.rx.value.subscribe { [weak self] event in
            guard let strongSelf = self, let index = event.element else { return }
            strongSelf.childSelectionDidChange(toIndex: index)
        }.disposed(by: disposeBag)
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
