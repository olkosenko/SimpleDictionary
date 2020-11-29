//
//  CirclesView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-04.
//

import SwiftUI

struct CirclesView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let startAngle = Angle(degrees: 0)
                let endAngle = Angle(degrees: -180)
                
                let center = CGPoint(x: 150, y: 150)
                let radius: CGFloat = 150
                let start = CGPoint(
                    x: center.x + radius * cos(CGFloat(startAngle.radians)),
                    y: center.y + radius * sin(CGFloat(startAngle.radians)))
                
                path.move(to: start)
                path.addArc(center: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
                path.move(to: center)
            }
            .foregroundColor(.blue)
        }
    }
}

struct CirclesView_Previews: PreviewProvider {
    static var previews: some View {
        CirclesView()
    }
}
