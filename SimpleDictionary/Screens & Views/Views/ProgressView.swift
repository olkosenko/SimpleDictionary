//
//  ProgressView.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-03.
//

import SwiftUI

struct ProgressView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    makeLabel(title: "Search", result: "10", goal: "30", metric: "word", color: .red)
                    makeLabel(title: "Learn", result: "5", goal: "10", metric: "word", color: Color.blue.opacity(0.8))
                    makeLabel(title: "Time", result: "3", goal: "10", metric: "minutes", color: Color.green.opacity(0.8))
                }
                .padding(.leading)
                Spacer()
            }
            Spacer()
        }
        .background(Color.red.opacity(0.2))
        .cornerRadius(20)
        .frame(height: 200)
    }
    
    func makeLabel(title: String, result: String, goal: String, metric: String, color: Color) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(.callout, design: .rounded))
                .foregroundColor(.black)
            Text("\(result)/\(goal) \(metric)")
                .font(.system(.body, design: .rounded))
                .bold()
                .foregroundColor(color)
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .previewLayout(.fixed(width: 400, height: 400))
            .padding()
    }
}
