//
//  DropdownItem.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-08.
//

import SwiftUI

struct DropdownItem: View {
    
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .foregroundColor(.purple)
                .padding(4)
            
            Text(text)
            
            Spacer()
        }
    }
}

struct DropdownItem_Previews: PreviewProvider {
    static var previews: some View {
        DropdownItem(text: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
            .previewLayout(.fixed(width: 400, height: 200))
    }
}
