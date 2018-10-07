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
import RxDataSources

final class LeaguesListViewController: UITableViewController {
    
    var store: Store<AppState>!
    
    private let leagueSections = Variable<[LeaguesListTableViewSection]>([LeaguesListTableViewSection(title: "Default", leagues: [])])
    
    private let disposeBag = DisposeBag()
    
    internal lazy var connection = Connection(
        store: store,
        mapStateToProps: mapStateToProps,
        mapDispatchToActions: mapDispatchToActions
    )
    
    private lazy var loadingViewController: UIAlertController = self.loadingViewController(withTitle: "Loading leagues")
    
    private var loadingViewControllerShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupConnection()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actions.selectLeague(leagueSections.value[0].leagues[indexPath.row])
        performSegue(withIdentifier: identifierForSegue(fromViewControllerOfType: LeaguesListViewController.self, toViewControllerOfType: LeagueHostViewController.self)!, sender: self)
    }
    
    private func setupConnection() {
        connection.subscribe(\Props.leaguesLoadable) { [weak self] (loadable) in
            guard let this = self else { return }
            switch loadable {
            case .value(let newLeagues):
                this.leagueSections.value[0].leagues.append(contentsOf: newLeagues.data)
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
    
    private func setupTableView() {
        tableView.dataSource = nil
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<LeaguesListTableViewSection>(configureCell: { (dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: LeaguesListTableViewCell.identifier, for: indexPath) as! LeaguesListTableViewCell
            cell.leagueNameLabel.text = item.name
            cell.badgeURL = item.badge ?? item.logo
            return cell
        })
        
        leagueSections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension LeaguesListViewController: Connectable {
    typealias AppStateType = AppState
    
    typealias PropsType = LeaguesListViewController.Props
    
    typealias ActionsType = LeaguesListViewController.Actions
    
    struct Props {
        let leaguesLoadable: Loadable<EquatableArray<League>>
        let selectedLeague: League?
    }
    struct Actions {
        let fetchLeagues: () -> Void
        let selectLeague: (League) -> Void
    }
}

private let mapStateToProps = { (appState: AppState) in
    return LeaguesListViewController.Props(leaguesLoadable: appState.leaguesListState.leaguesLoadable, selectedLeague: appState.leaguesListState.selectedLeague)
}

private let mapDispatchToActions = { (dispatch: @escaping DispatchFunction) in
    return LeaguesListViewController.Actions(
        fetchLeagues: { dispatch(LeaguesListAction.fetch) },
        selectLeague: { dispatch(LeaguesListAction.selectLeague($0)) }
    )
}
