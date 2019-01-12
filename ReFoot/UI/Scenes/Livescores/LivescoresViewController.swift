//
//  LivescoresViewController.swift
//  ReFoot
//
//  Created by merengue on 11/01/2019.
//  Copyright © 2019 merengue. All rights reserved.
//

import UIKit
import ReSwift
import RxSwift
import ReRxSwift
import RxDataSources

final class LivescoresViewController: UITableViewController, ShowsLoadingAlert {

    static let identifier = "LivescoresViewController"
    
    var store: Store<AppState>!
    
    internal lazy var connection = Connection(
        store: store,
        mapStateToProps: mapStateToProps,
        mapDispatchToActions: mapDispatchToActions
    )
    
    private let disposeBag = DisposeBag()
    
    private let tableViewSections = Variable<[RxTableViewAnimatableTitledSection<LiveMatchEvent>]>([])

    lazy var loadingViewController: UIAlertController = self.loadingViewController(withTitle: "Loading events")
    
    var loadingViewControllerShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.connect()
        setupConnection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissLoadingAlertIfNotAlreadyDismissed()
        tableViewSections.value = []
        connection.disconnect()
    }
    
    private func setupConnection() {
        connection.subscribe(\Props.liveMatchEventsLoadable) { [weak self] (loadable) in
            guard let this = self else { return }
            switch loadable {
            case .value(let newEvents):
                let sections = Dictionary(grouping: newEvents.data, by: { $0.leagueName }).map { (leagueName, events) in
                    RxTableViewAnimatableTitledSection<LiveMatchEvent>(title: leagueName, sectionItems: events)
                }
                this.tableViewSections.value.append(contentsOf: sections)
                this.dismissLoadingAlertIfNotAlreadyDismissed()
            case .loading:
                this.showLoadingAlertIfNotShowing()
            default:
                break
            }
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: EventTableViewCell.identifier)
        tableView.dataSource = nil
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<RxTableViewAnimatableTitledSection<LiveMatchEvent>>(configureCell: { (dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as! EventTableViewCell
            cell.homeTeamNameLabel.text = item.homeTeamName
            cell.awayTeamNameLabel.text = item.awayTeamName
            cell.homeTeamScoreLabel.text = item.homeScore
            cell.awayTeamScoreLabel.text = item.awayScore
            return cell
        })
        
        dataSource.titleForHeaderInSection = { [weak self] (dataSource, section) in
            return self?.tableViewSections.value[section].title ?? Placeholder.unknown
        }
        
        tableViewSections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension LivescoresViewController: Connectable {
    typealias AppStateType = AppState
    
    typealias PropsType = LivescoresViewController.Props
    
    typealias ActionsType = LivescoresViewController.Actions
    
    struct Props {
        let liveMatchEventsLoadable: Loadable<EquatableArray<LiveMatchEvent>>
    }
    
    struct Actions {}
}

private let mapStateToProps = { (appState: AppState) in
    return LivescoresViewController.Props(liveMatchEventsLoadable: appState.livescoresState.livescores)
}

private let mapDispatchToActions = { (dispatch: @escaping DispatchFunction) in
    return LivescoresViewController.Actions()
}
