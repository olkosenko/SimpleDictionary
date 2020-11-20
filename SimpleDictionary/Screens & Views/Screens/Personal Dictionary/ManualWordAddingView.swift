//
//  ManualWordAddingView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-19.
//

import SwiftUI

struct ManualWordAddingView: View {
    
    @State var items: [String] = ["Hi"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Word")) {
                        TextField("Enter your word", text: .constant(""))
                    }
                    Section(header: Text("Definitions")) {
                        ForEach(0..<items.count, id: \.self) { _ in
                            TextField("Enter your definition",
                                      text: .constant(""),
                                      onCommit:  {
                                        items.append("")
                                      })
                        }
                    }
                }
                .navigationBarTitle("New Word", displayMode: .inline)
                
                SaveButton()
            }
        }
    }
    
//    func buttonOffset(in size: CGSize) -> CGSize {
//        let bottomPadding: CGFloat = 10
//        let trailingPadding: CGFloat = 20
//
//        let heightOffset = size.height / 2 - buttonSize / 2 - bottomPadding
//        let widthOffset = size.width / 2 - buttonSize / 2 - trailingPadding
//
//        return CGSize(width: widthOffset, height: heightOffset)
//    }
}

struct ManualWordAddingView_Previews: PreviewProvider {
    static var previews: some View {
        ManualWordAddingView()
    }
}
