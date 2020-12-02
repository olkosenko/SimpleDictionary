//
//  CirclesView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-04.
//

import SwiftUI

struct CirclesView: View {
   
    let progress: Double
    let thickness: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            ProgressCircle(progress: 1, thickness: thickness)
                .foregroundColor(color.opacity(0.3))
            ProgressCircle(progress: progress, thickness: thickness)
                .foregroundColor(color)
        }
    }
}

struct CirclesView_Previews: PreviewProvider {
    static var previews: some View {
        CirclesView(progress: 0.5, thickness: 30, color: .blue)
    }
}
