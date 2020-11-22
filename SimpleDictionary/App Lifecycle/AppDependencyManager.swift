//
//  AppDependencyManager.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-21.
//

import Foundation
import ComposableArchitecture

class AppDependencyManager {
    let coreDataStore: CoreDataStore
    let apiService: APIService
    let coreDataService: CoreDataService
    let wodDataProvider: WODDataProvider
    let personalDictionaryDataProvider: PersonalDictionaryDataProvider
    
    init() {
        coreDataStore = CoreDataStore()
        apiService = APIService()
        coreDataService = CoreDataService(context: coreDataStore.mainContext)
        wodDataProvider = WODDataProvider(apiService: apiService, coreDataService: coreDataService)
        personalDictionaryDataProvider = PersonalDictionaryDataProvider(coreDataService: coreDataService)
    }
}
