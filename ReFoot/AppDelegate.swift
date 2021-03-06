//
//  AppDelegate.swift
//  ReFoot
//
//  Created by merengue on 22/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard
import ReSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        
        setupDependencies()
        
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: SwinjectStoryboard.defaultContainer)
        window.rootViewController = storyboard.instantiateInitialViewController()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func setupDependencies() {
        Container.loggingFunction = nil
        
        // repo
        SwinjectStoryboard.defaultContainer.register(CacheFootballDataStore.self) { _ in
            CacheFootballDataStoreImpl()
        }.inObjectScope(.container)
        
        SwinjectStoryboard.defaultContainer.register(RemoteFootballDataStore.self) { _ in
            RemoteFootballDataStoreImpl()
        }
        
        SwinjectStoryboard.defaultContainer.register(FootballRepository.self) { resolver in
            FootballRepositoryImpl(remote: resolver.resolve(RemoteFootballDataStore.self)!, cache: resolver.resolve(CacheFootballDataStore.self)!)
        }
        
        // store
        SwinjectStoryboard.defaultContainer.register(Store<AppState>.self) { resolver in
            Store<AppState>(
                reducer: appReducer,
                state: nil,
                middleware: [
                    createMiddleware(leaguesMiddleware(using: resolver.resolve(FootballRepository.self)!)),
                    createMiddleware(dayEventsMiddleware(using: resolver.resolve(FootballRepository.self)!)),
                    createMiddleware(scoresHostMiddleware),
                    createMiddleware(livescoresMiddleware(using: resolver.resolve(FootballRepository.self)!))
                ]
            )
        }.inObjectScope(.container)
        
        // viewControllers
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(ScoresHostViewController.self) { resolver, viewController in
            viewController.store = resolver.resolve(Store<AppState>.self)!
        }
        
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(LeaguesListViewController.self) { resolver, viewController in
            viewController.store = resolver.resolve(Store<AppState>.self)!
        }
        
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(LivescoresHostViewController.self) { resolver, viewController in
            
        }
        
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(LivescoresViewController.self) { resolver, viewController in
            viewController.store = resolver.resolve(Store<AppState>.self)!
        }
        
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(DayEventsViewController.self) { resolver, viewController in
            viewController.store = resolver.resolve(Store<AppState>.self)!
        }
        
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(LeagueInfoViewController.self) { resolver, viewController in
        }
        
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(LeagueTableViewController.self) { resolver, viewController in
        }
        
        SwinjectStoryboard.defaultContainer.storyboardInitCompleted(LeagueTeamsViewController.self) { resolver, viewController in
            viewController.store = resolver.resolve(Store<AppState>.self)!
        }
    }
}

