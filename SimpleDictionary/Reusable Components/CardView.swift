//
//  CardView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-09.
//

import SwiftUI

struct CardView: View {
    
    @State private var isHovered = false
    
    var tap: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { val in
                print("Down: \(val)")
            }
            .onEnded { val in
                print("Up: \(val)")
            }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue.opacity(0.8))
            
            VStack {
                Spacer()
                
                Text("Hello")
                    .font(.title)
                    .padding(.bottom, 8)
                
                Text("Used when meeting or greeting someone.")
                    .font(.body)
                    .foregroundColor(Color.gray)
                
                Spacer()
                
                Text("September 06, 2020")
                    .foregroundColor(.blue)
                    .font(Font.custom("Futura Medium", size: 16))
            }
            .padding()
        }
        .frame(maxHeight: 200)
        .scaleEffect(isHovered ? 0.9 : 1)
        .onHover {
            self.isHovered = $0
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .previewLayout(.fixed(width: 400, height: 500))
    }
}
