//
//  CardView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-09.
//

import SwiftUI

struct CardView: View {
    
    let wod: WordnikWOD
    
    var body: some View {
        NavigationLink(destination: SearchResultsView(word: wod.word!.capitalizeFirst())) {
            VStack {
                
                Text(wod.word!.capitalizeFirst())
                    .font(Font.custom("Baskerville SemiBold", size: 28))
                    .padding(.top, 8)
                
                Text(wod.definitions!.first!.partOfSpeech!)
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 4)
                    .lineLimit(3)
                
                Text(wod.definitions!.first!.text!)
                    .font(.body)
                
                Spacer()
                
                Divider()
                
                HStack {
                    Text("Word of the Day")
                        .font(Font.custom("Futura Medium", size: 12))
                    
                    Spacer()
                    
                    Text("September 09, 2020")
                        .font(Font.custom("Futura Medium", size: 12))
                }
                .padding(.bottom, 8)
            }
            .padding([.leading, .trailing])
            .background(Color.blue
                            .opacity(0.1)
                            .shadow(radius: 10))
            .cornerRadius(10)
            .frame(maxHeight: 200)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(backgroundColor: Color.blue)
//            .previewLayout(.fixed(width: 400, height: 500))
//            .padding()
//    }
//}
