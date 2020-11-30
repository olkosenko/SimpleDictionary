//
//  CardView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-09.
//

import SwiftUI
import ComposableArchitecture

struct CardView: View {
    
    let title: String
    let partOfSpeech: String
    let definition: String
    let date: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(Font.custom("Baskerville SemiBold", size: 28,relativeTo: .largeTitle))
                .padding(.top, 8)
            
            Text(partOfSpeech)
                .font(.subheadline)
                .italic()
                .foregroundColor(Color.gray)
            
            Spacer()
            
            Text(definition)
                .lineLimit(4)
                .font(.body)
                .minimumScaleFactor(0.95)
            
            Spacer()
            
            Divider()
            
            bottomBar
                .padding(.vertical, 8)
        }
        .padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 10)
                        .shadow(color: .black, radius: 4, x: 1.0, y: 1.0)
                        .foregroundColor(.cardViewBackground))
        .frame(height: 200)
        .frame(maxWidth: 400)
    }
    
    private var bottomBar: some View {
        HStack {
            Text("Word of the Day")
                .font(Font.custom("Futura Medium", size: 12))
            
            Spacer()
            
            Text(date)
                .font(Font.custom("Futura Medium", size: 12))
        }
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(title: "Edge",
                 partOfSpeech: "noun",
                 definition: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Consectetur adipiscing elit. consectetur adipiscing elit. consectetur adipiscing elit.",
                 date: Date().wod
        )
        .previewLayout(.fixed(width: 400, height: 500))
        .padding()
    }
}
