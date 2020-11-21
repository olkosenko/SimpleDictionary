//
//  SimpleDictionaryApp.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import SwiftUI

@main
struct SimpleDictionaryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var a
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: .init(
                    initialState: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment(mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                                                wodDataProdiver: WODDataProvider(apiService: a.apiService,
                                                                                 coreDataService: a.coreDataService),
                                                personalDictionaryDataProvider: PersonalDictionaryDataProvider(apiService: a.apiService,
                                                                                                               coreDataService: a.coreDataService)))
            )
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let coreDataService: CoreDataService = {
        let coreDataStore = CoreDataStore()
        return CoreDataService(context: coreDataStore.mainContext)
    }()
    let apiService = APIService()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }
}
