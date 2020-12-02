//
//  ProgressCircle.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-12-01.
//

import SwiftUI

struct ProgressCircle: Shape {
    
    /// Value within 0...1
    var progress: Double
    let thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var endAngleDegrees: Double
        if progress == 1 {
            endAngleDegrees = 270.0001
        } else {
            endAngleDegrees = (1 - progress) * 360 + 270
        }
        
        let startAngle = Angle(degrees: 270)
        let endAngle = Angle(degrees: endAngleDegrees)
        let center = CGPoint(x: rect.midX, y: rect.midY)

        let bigRadius = min(rect.width, rect.height) / 2
        let bigStart = CGPoint(
            x: center.x + bigRadius * cos(CGFloat(startAngle.radians)),
            y: center.y + bigRadius * sin(CGFloat(startAngle.radians))
        )
        
        let smallRadius = bigRadius - thickness
        
        var path = Path()
        
        path.move(to: bigStart)
        
        path.addArc(center: center,
                    radius: bigRadius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
        
        path.addArc(center: center,
                    radius: smallRadius,
                    startAngle: endAngle,
                    endAngle: startAngle,
                    clockwise: false)
        
        return path
    }
}

struct ProgressCircle_Previews: PreviewProvider {

    static var previews: some View {
        ZStack {
            ProgressCircle(progress: 1, thickness: 50)
                .foregroundColor(Color.blue.opacity(0.3))
            ProgressCircle(progress: 10/25, thickness: 50)
                .foregroundColor(.blue)
        }
    }
}
