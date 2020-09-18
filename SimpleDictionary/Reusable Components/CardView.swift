//
//  CardView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-09.
//

import SwiftUI

struct CardView: View {
    
    @State private var isHovered = false
    let backgroundColor: Color
    
    var tap: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { val in
                if val.location.x > 0 && val.location.x < 300 &&
                    val.location.y > 0 && val.location.y < 200 {
                    withAnimation {
                        isHovered = true
                    }
                } else {
                    withAnimation {
                        isHovered = false
                    }
                }
            }
            .onEnded { val in
                withAnimation {
                    isHovered = false
                }
            }
    }
    
    var body: some View {
        NavigationLink(destination: HistoryView()) {
            VStack {
                
                Text("Architourist")
                    .font(Font.custom("Baskerville SemiBold", size: 28))
                    .padding(.top, 8)
                
                Text("noun")
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 4)
                
                Text("A tourist whose primary activity involves seeing buildings and other architectural works.")
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
            .background(backgroundColor
                            .opacity(0.1)
                            .shadow(radius: 10))
            .cornerRadius(10)
            .scaleEffect(isHovered ? 0.95 : 1)
            // .gesture(tap)
            .frame(maxHeight: 200)
        }
    }
}



//Image(systemName: "hand.tap.fill")
//    .foregroundColor(.blue)
//    .offset(x: 150, y: -80)

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(backgroundColor: Color.blue)
            .previewLayout(.fixed(width: 400, height: 500))
            .padding()
    }
}
