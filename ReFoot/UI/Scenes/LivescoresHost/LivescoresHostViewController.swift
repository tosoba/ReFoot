//
//  LivescoresHostViewController.swift
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

final class LivescoresHostViewController: UIViewController {
    
    static let identifier = "LivescoresHostViewController"
    
    @IBOutlet weak var tableSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableContainerView: UIView!
    
    private let disposeBag = DisposeBag()
    
    private lazy var dayEventsViewController: DayEventsViewController = instantiateViewController(withIdentifier: DayEventsViewController.identifier, fromSwinjectStoryboardNamed: "DayEvents")
    
    private lazy var livescoresViewController: LivescoresViewController = instantiateViewController(withIdentifier: LivescoresViewController.identifier, fromSwinjectStoryboardNamed: "Livescores")
    
    private var currentChildViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSegmentedControl.rx.value
            .distinctUntilChanged()
            .subscribe { [weak self] event in
                guard case let .next(index) = event, let this = self else { return }
                if index == 0 {
                    this.show(childViewController: this.livescoresViewController, in: this.tableContainerView, updating: &this.currentChildViewController)
                } else if index == 1 {
                    this.show(childViewController: this.dayEventsViewController, in: this.tableContainerView, updating: &this.currentChildViewController)
                }
            }
            .disposed(by: disposeBag)
    }
}
