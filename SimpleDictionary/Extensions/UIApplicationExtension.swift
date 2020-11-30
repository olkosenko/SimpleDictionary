//
//  UIApplicationExtension.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-30.
//

import UIKit

extension UIApplication {
    /// Should be removed when built-in TextField gains support of resignFirstResponder
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
