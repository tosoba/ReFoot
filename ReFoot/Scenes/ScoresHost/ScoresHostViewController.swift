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

final class ScoresHostViewController: UIViewController {
    
    @IBOutlet weak var dateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    private let disposeBag = DisposeBag()
    
    private lazy var dayEventsViewController: DayEventsViewController = instantiateViewController(withIdentifier: DayEventsViewController.identifier, from: UIStoryboard(name: "DayEvents", bundle: Bundle.main))
    
    private lazy var livescoresViewController: LivescoresViewController = instantiateViewController(withIdentifier: LivescoresViewController.identifier, from: UIStoryboard(name: "Livescores", bundle: Bundle.main))
    
    private var currentChildViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDateSegmentedControl()
        
        dateSegmentedControl.rx.value.subscribe { [weak self] event in
            guard let strongSelf = self, let index = event.element else { return }
            //TODO: dispatch action to change date for loading events
            strongSelf.dateSelectionDidChange(toIndex: index)
        }.disposed(by: disposeBag)
    }
    
    private func dateSelectionDidChange(toIndex index: Int) {
        if index == 2 {
            show(childViewController: livescoresViewController, in: containerView, updating: &self.currentChildViewController)
        } else {
            show(childViewController: dayEventsViewController, in: containerView, updating: &self.currentChildViewController)
        }
    }
    
    private func setupDateSegmentedControl() {
        let today = Date()
        let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: today)
        let dayAfterTommorow = Calendar.current.date(byAdding: .day, value: 2, to: today)
        
        dateSegmentedControl.setTitle(dayBeforeYesterday?.dayOfTheWeek, forSegmentAt: 0)
        dateSegmentedControl.setTitle(dayAfterTommorow?.dayOfTheWeek, forSegmentAt: 4)
    }
}
