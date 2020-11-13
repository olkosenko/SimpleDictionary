//
//  HistoryView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        Form {
            HStack {
                Button("Sign In") { print("Sign In") }
                Button("Sign Up") { print("Sign Up") }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
