//
//  SimpleDictionaryApp.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import SwiftUI
import ComposableArchitecture

@main
struct SimpleDictionaryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment(
                        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                        searchDataProvider: appDelegate.dependencyManager.searchDataProvider,
                        personalDictionaryDataProvider: appDelegate.dependencyManager.personalDictionaryDataProvider,
                        gameDataProvider: appDelegate.dependencyManager.gameDataProvider,
                        userDefaultsDataProvider: appDelegate.dependencyManager.userDefaultsDataProvider)))
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    let dependencyManager = AppDependencyManager()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        configureUserDefaults()
        
        return true
    }
    
    private func configureUserDefaults() {
        var searchSettings = UserDefaults.searchSettings
        if Calendar.current.compare(searchSettings.dateActive, to: Date(), toGranularity: .day) != .orderedSame {
            searchSettings.currentSearchCount = 0
            searchSettings.currentLearnCount = 0
            UserDefaults.searchSettings = searchSettings
        }
    }
}
