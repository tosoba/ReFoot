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
import FoldingCell

final class LeagueTeamsViewController: UITableViewController, ShowsLoadingAlert {
    
    static let identifier = "LeagueTeamsViewController"
    
    var store: Store<AppState>!
    
    internal lazy var connection = Connection(
        store: store,
        mapStateToProps: mapStateToProps,
        mapDispatchToActions: mapDispatchToActions
    )
    
    lazy var loadingViewController: UIAlertController = self.loadingViewController(withTitle: "Loading teams")
    
    var loadingViewControllerShowing: Bool = false
    
    private let disposeBag = DisposeBag()
    
    private let teamSections = Variable<[RxTableViewAnimatableTitledSection<Team>]>([RxTableViewAnimatableTitledSection(title: "Default", sectionItems: [])])
    
    struct CellHeight {
        static let closed: CGFloat = 75 // equal or greater foregroundView height
        static let open: CGFloat = 456 // equal or greater containerView height
    }
    
    var cellHeights: [CGFloat] = []
    
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
        dismissLoadingAlertIfNotAlreadyDismissed()
        connection.disconnect()
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = CellHeight.closed
        tableView.dataSource = nil
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<RxTableViewAnimatableTitledSection<Team>>(configureCell: { (dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: LeagueTeamsTableViewCell.identifier, for: indexPath) as! LeagueTeamsTableViewCell
            cell.teamBadgeImageView.loadFromURL(item.teamBadgeURL)
            cell.teamJerseyImageView.loadFromURL(item.teamJerseyURL)
            cell.teamBannerImageView.loadFromURL(item.teamBannerURL)
            cell.teamNameForegroundLabel.text = item.name
            cell.teamNameContainerLabel.text = item.name
            return cell
        })
        
        teamSections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupConnection() {
        connection.subscribe(\Props.teamsLoadable) { [weak self] (loadable) in
            guard let this = self else { return }
            switch loadable {
            case .value(let teams):
                this.teamSections.value[0].sectionItems.append(contentsOf: teams.data)
                this.cellHeights = Array(repeating: CellHeight.closed, count: this.teamSections.value[0].sectionItems.count)
                this.dismissLoadingAlertIfNotAlreadyDismissed()
            case .loading:
                this.showLoadingAlertIfNotShowing()
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
    return LeagueTeamsViewController.Props(teamsLoadable: appState.leaguesState.teams[appState.leaguesState.selectedLeague!.id] ?? .initial)
}

private let mapDispatchToActions = { (dispatch: @escaping DispatchFunction) in
    return LeagueTeamsViewController.Actions()
}

extension LeagueTeamsViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == CellHeight.closed
        if cellIsCollapsed {
            cellHeights[indexPath.row] = CellHeight.open
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = CellHeight.closed
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let foldingCell as FoldingCell = cell {
            if cellHeights[indexPath.row] == CellHeight.closed {
                foldingCell.unfold(false, animated: false, completion: nil)
            } else {
                foldingCell.unfold(true, animated: false, completion: nil)
            }
        }
    }
}

