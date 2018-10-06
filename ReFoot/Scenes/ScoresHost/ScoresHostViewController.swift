//
//  MainScoresViewController.swift
//  ReFoot
//
//  Created by merengue on 22/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import ReRxSwift

final class ScoresHostViewController: UIViewController {
    
    @IBOutlet weak var dateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var store: Store<AppState>!
    
    internal lazy var connection = Connection(
        store: store,
        mapStateToProps: mapStateToProps,
        mapDispatchToActions: mapDispatchToActions
    )
    
    private let disposeBag = DisposeBag()
    
    private lazy var dayEventsViewController: DayEventsViewController = instantiateViewController(withIdentifier: DayEventsViewController.identifier, fromSwinjectStoryboardNamed: "DayEvents")
    
    private lazy var livescoresViewController: LivescoresViewController = instantiateViewController(withIdentifier: LivescoresViewController.identifier, fromSwinjectStoryboardNamed: "Livescores")
    
    private var currentChildViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDateSegmentedControl()
        
        dateSegmentedControl.rx.value
            .distinctUntilChanged()
            .subscribe { [weak self] event in
                guard case let .next(index) = event, let this = self else { return }
                this.dateSelectionDidChange(toIndex: index)
            }
            .disposed(by: disposeBag)
    }
    
    private func dateSelectionDidChange(toIndex index: Int) {
        if index == 2 {
            show(childViewController: livescoresViewController, in: containerView, updating: &self.currentChildViewController)
        } else {
            actions.setDate(indexDates[index]!)
            show(childViewController: dayEventsViewController, in: containerView, updating: &self.currentChildViewController)
        }
    }
    
    private func setupDateSegmentedControl() {
        dateSegmentedControl.setTitle(indexDates[0]!.dayOfTheWeek, forSegmentAt: 0)
        dateSegmentedControl.setTitle(indexDates[4]!.dayOfTheWeek, forSegmentAt: 4)
    }
}

extension ScoresHostViewController: Connectable {
    typealias AppStateType = AppState
    
    typealias PropsType = ScoresHostViewController.Props
    
    typealias ActionsType = ScoresHostViewController.Actions
    
    struct Props {}
    
    struct Actions {
        let setDate: (Date) -> Void
    }
}

private let mapStateToProps = { (appState: AppState) in
    return ScoresHostViewController.Props()
}

private let mapDispatchToActions = { (dispatch: @escaping DispatchFunction) in
    return ScoresHostViewController.Actions(setDate: { dispatch(ScoresHostAction.set($0)) }
    )
}

private let indexDates = [
    0: Date.today.offsetBy(days: -2),
    1: Date.today.offsetBy(days: -1),
    2: Date.today,
    3: Date.today.offsetBy(days: 1),
    4: Date.today.offsetBy(days: 2)
]
