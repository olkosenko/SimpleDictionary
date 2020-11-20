//
//  PersonalDictionary.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-18.
//

import SwiftUI

struct PersonalDictionary: View {
    
    let buttonSize: CGFloat = 55
    @State var isPresented = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                NavigationView {
                    form
                        .sheet(isPresented: $isPresented) {
                            ManualWordAddingView()
                        }
                    .navigationTitle("Dictionary")
                }
                
                AddButton { isPresented = true }
                    .frame(width: buttonSize, height: buttonSize)
                    .offset(buttonOffset(in: proxy.size))
            }
        }
    }
    
    var form: some View {
        Form {
            ForEach(0..<1000, id: \.self) { number in
                NavigationLink(destination: Text("\(number)")) {
                    Text("Word \(number)")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    func buttonOffset(in size: CGSize) -> CGSize {
        let bottomPadding: CGFloat = 10
        let trailingPadding: CGFloat = 20
        
        let heightOffset = size.height / 2 - buttonSize / 2 - bottomPadding
        let widthOffset = size.width / 2 - buttonSize / 2 - trailingPadding
        
        return CGSize(width: widthOffset, height: heightOffset)
    }
    
}

struct PersonalDictionary_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDictionary()
    }
}
