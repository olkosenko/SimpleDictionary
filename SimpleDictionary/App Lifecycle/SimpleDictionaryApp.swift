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
        configureAppearance()
        
        return true
    }
    
    private func configureUserDefaults() {
        UserDefaults.standard.register(defaults: [
            "isDictionaryDateShown": false
        ])
    }
    
    private func configureAppearance() {
        // UINavigationBar.appearance().backgroundColor = UIColor(Color.appBackground)
    }
}
