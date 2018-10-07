//
//  LeagueTeamsViewController.swift
//  ReFoot
//
//  Created by merengue on 22/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import ReSwift
import RxSwift
import ReRxSwift
import RxDataSources

final class LeagueTeamsViewController: UIViewController {

    static let identifier = "LeagueTeamsViewController"
    
    var store: Store<AppState>!
    
    internal lazy var connection = Connection(
        store: store,
        mapStateToProps: mapStateToProps,
        mapDispatchToActions: mapDispatchToActions
    )
    
    private lazy var loadingViewController: UIAlertController = self.loadingViewController(withTitle: "Loading teams")
    
    private var loadingViewControllerShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        connection.disconnect()
        loadingViewControllerShowing = false
    }
    
    private func setupConnection() {
        connection.subscribe(\Props.teamsLoadable) { [weak self] (loadable) in
            guard let this = self else { return }
            switch loadable {
            case .value(let teams):
                if this.loadingViewControllerShowing {
                    this.dismiss(animated: true, completion: nil)
                    this.loadingViewControllerShowing = false
                }
            case .loading:
                this.present(this.loadingViewController, animated: true, completion: nil)
                this.loadingViewControllerShowing = true
            default:
                break
            }
        }
    }
}


extension LeagueTeamsViewController: Connectable {
    typealias AppStateType = AppState
    
    typealias PropsType = LeagueTeamsViewController.Props
    
    typealias ActionsType = LeagueTeamsViewController.Actions
    
    struct Props {
        let teamsLoadable: Loadable<EquatableArray<Team>>
    }
    
    struct Actions {}
}

private let mapStateToProps = { (appState: AppState) in
    return LeagueTeamsViewController.Props(teamsLoadable: appState.leagueTeamsState.leagueTeams[appState.leaguesListState.selectedLeague!.id] ?? .initial)
}

private let mapDispatchToActions = { (dispatch: @escaping DispatchFunction) in
    return LeagueTeamsViewController.Actions()
}
