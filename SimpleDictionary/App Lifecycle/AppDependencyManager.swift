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
    let searchDataProvider: SearchDataProvider
    let personalDictionaryDataProvider: PersonalDictionaryDataProvider
    let userDefaultsDataProvider: UserDefaultsDataProvider
    
    init() {
        coreDataStore = CoreDataStore()
        apiService = APIService()
        coreDataService = CoreDataService(context: coreDataStore.mainContext)
        searchDataProvider = SearchDataProvider(apiService: apiService, coreDataService: coreDataService)
        personalDictionaryDataProvider = PersonalDictionaryDataProvider(coreDataService: coreDataService)
        userDefaultsDataProvider = UserDefaultsDataProvider()
    }
}
