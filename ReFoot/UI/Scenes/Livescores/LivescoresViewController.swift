//
//  LivescoresViewController.swift
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

final class LivescoresViewController: UIViewController {
    
    static let identifier = "LivescoresViewController"
    
    var store: Store<AppState>!
    
    internal lazy var connection = Connection(
        store: store,
        mapStateToProps: mapStateToProps,
        mapDispatchToActions: mapDispatchToActions
    )
    
    private let disposeBag = DisposeBag()
    
    private lazy var loadingViewController: UIAlertController = self.loadingViewController(withTitle: "Loading events")
    
    private var loadingViewControllerShowing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        connection.connect()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            connection.disconnect()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        connection.disconnect()
        loadingViewControllerShowing = false
    }
    
    private func setupConnection() {
        connection.subscribe(\Props.allMatchEventsLoadable) { [weak self] loadable in
            guard let this = self else { return }
            switch loadable {
            case .value(let newEvents):
                self?.hideLoadingViewControllerIfShowing()
            case .loading:
                this.present(this.loadingViewController, animated: true, completion: nil)
                this.loadingViewControllerShowing = true
            case .error(let error):
                break
            default:
                break
            }
        }
        
        connection.subscribe(\Props.liveEventsLoadable) { [weak self] loadable in
            guard let this = self else { return }
            switch loadable {
            case .value(let newLiveEvents):
                print(newLiveEvents.data.count)
                self?.hideLoadingViewControllerIfShowing()
            case .error(let error):
                break
            default:
                break
            }
        }
    }
    
    private func hideLoadingViewControllerIfShowing() {
        if loadingViewControllerShowing {
            dismiss(animated: true, completion: nil)
            loadingViewControllerShowing = false
        }
    }
}

extension LivescoresViewController: Connectable {
    typealias AppStateType = AppState
    
    typealias PropsType = LivescoresViewController.Props
    
    typealias ActionsType = LivescoresViewController.Actions
    
    struct Props {
        let liveEventsLoadable: Loadable<EquatableArray<LiveMatchEvent>>
        let allMatchEventsLoadable: Loadable<EquatableArray<MatchEvent>>
    }
    
    struct Actions {}
}

private let mapStateToProps = { (appState: AppState) in
    return LivescoresViewController.Props(
        liveEventsLoadable: appState.livescoresState.livescores,
        allMatchEventsLoadable: appState.dayEventsState.events[appState.scoresHostState.date.toStringYearMonthDay()] ?? .initial)
}

private let mapDispatchToActions = { (dispatch: @escaping DispatchFunction) in
    return LivescoresViewController.Actions()
}
