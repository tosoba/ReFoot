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

final class DayEventsViewController: UITableViewController {
    
    static let identifier = "DayEventsViewController"
    
    var store: Store<AppState>!
    
    internal lazy var connection = Connection(
        store: store,
        mapStateToProps: mapStateToProps,
        mapDispatchToActions: mapDispatchToActions
    )
    
    private let disposeBag = DisposeBag()
    
    private let dayEventsSections = Variable<[RxTableViewAnimatableTitledSection<MatchEvent>]>([])
    
    private lazy var loadingViewController: UIAlertController = self.loadingViewController(withTitle: "Loading events")
    
    private var loadingViewControllerShowing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
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
        dayEventsSections.value = []
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            connection.disconnect()
        }
    }
    
    private func setupConnection() {
        connection.subscribe(\Props.matchEventsLoadable) { [weak self] (loadable) in
            guard let this = self else { return }
            switch loadable {
            case .value(let newEvents):
                let sections = Dictionary(grouping: newEvents.data, by: { $0.leagueName }).map { (leagueName, events) in
                    RxTableViewAnimatableTitledSection<MatchEvent>(title: leagueName, sectionItems: events)
                }
                this.dayEventsSections.value.append(contentsOf: sections)
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
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<RxTableViewAnimatableTitledSection<MatchEvent>>(configureCell: { (dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: DayEventsTableViewCell.identifier, for: indexPath) as! DayEventsTableViewCell
            cell.homeTeamNameLabel.text = item.homeTeamName
            cell.awayTeamNameLabel.text = item.awayTeamName
            cell.homeTeamScoreLabel.text = item.homeScore
            cell.awayTeamScoreLabel.text = item.awayScore
            return cell
        })
        
        dataSource.titleForHeaderInSection = { [weak self] (dataSource, section) in
            return self?.dayEventsSections.value[section].title ?? Placeholder.unknown
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
