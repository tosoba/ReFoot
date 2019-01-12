//
//  DayEventsViewController.swift
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

final class DayEventsViewController: UITableViewController, ShowsLoadingAlert {
    
    static let identifier = "DayEventsViewController"
    
    var store: Store<AppState>!
    
    internal lazy var connection = Connection(
        store: store,
        mapStateToProps: mapStateToProps,
        mapDispatchToActions: mapDispatchToActions
    )
    
    private let disposeBag = DisposeBag()
    
    private let dayEventsSections = Variable<[RxTableViewAnimatableTitledSection<MatchEvent>]>([])
    
    lazy var loadingViewController: UIAlertController = self.loadingViewController(withTitle: "Loading events")
    
    var loadingViewControllerShowing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConnection()
        connection.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissLoadingAlertIfNotAlreadyDismissed()
        dayEventsSections.value = []
        connection.disconnect()
    }
    
    private func setupConnection() {
        connection.subscribe(\Props.matchEventsLoadable) { [weak self] (loadable) in
            guard let this = self else { return }
            switch loadable {
            case .value(let newEvents):
                let sections = Dictionary(grouping: newEvents.data, by: { $0.leagueName }).map { (leagueName, events) in
                    RxTableViewAnimatableTitledSection<MatchEvent>(title: leagueName, sectionItems: events)
                }
                this.dayEventsSections.value = []
                this.dayEventsSections.value.append(contentsOf: sections)
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
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<RxTableViewAnimatableTitledSection<MatchEvent>>(configureCell: { (dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as! EventTableViewCell
            cell.homeTeamNameLabel.text = item.homeTeamName
            cell.awayTeamNameLabel.text = item.awayTeamName
            cell.homeTeamScoreLabel.text = item.homeScore
            cell.awayTeamScoreLabel.text = item.awayScore
            return cell
        })
        
        dataSource.titleForHeaderInSection = { [weak self] (dataSource, section) in
            guard let this = self else { return Placeholder.unknown }
            if this.dayEventsSections.value.count - 1 < section {
                return Placeholder.unknown
            }
            return this.dayEventsSections.value[section].title
        }
        
        dayEventsSections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension DayEventsViewController: Connectable {
    typealias AppStateType = AppState
    
    typealias PropsType = DayEventsViewController.Props
    
    typealias ActionsType = DayEventsViewController.Actions
    
    struct Props {
        let matchEventsLoadable: Loadable<EquatableArray<MatchEvent>>
    }
    
    struct Actions {}
}

private let mapStateToProps = { (appState: AppState) in
    return DayEventsViewController.Props(matchEventsLoadable: appState.dayEventsState.events[appState.scoresHostState.date.toStringYearMonthDay()] ?? .initial)
}

private let mapDispatchToActions = { (dispatch: @escaping DispatchFunction) in
    return DayEventsViewController.Actions()
}
