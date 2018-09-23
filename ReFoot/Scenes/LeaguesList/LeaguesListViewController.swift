//
//  LeaguesListViewController.swift
//  ReFoot
//
//  Created by merengue on 22/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import ReSwift
import RxSwift
import ReRxSwift

class LeaguesListViewController: UIViewController {
    
    var store: Store<AppState>!
    
    internal lazy var connection = {return Connection(
        store: store,
        mapStateToProps: mapStateToProps,
        mapDispatchToActions: mapDispatchToActions
        )}()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        actions.fetchLeagues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.connect()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        connection.disconnect()
    }
}

extension LeaguesListViewController: Connectable {
    typealias AppStateType = AppState
    
    typealias PropsType = LeaguesListViewController.Props
    
    typealias ActionsType = LeaguesListViewController.Actions
    
    struct Props {
        let leagues: Loadable<[League]>
    }
    struct Actions {
        let fetchLeagues: () -> ()
    }
}

private let mapStateToProps = { (appState: AppState) in
    return LeaguesListViewController.Props(leagues: appState.leaguesListState.leagues)
}

private let mapDispatchToActions = { (dispatch: @escaping DispatchFunction) in
    return LeaguesListViewController.Actions(
        fetchLeagues: {  dispatch(LeaguesListAction.fetch) }
    )
}
