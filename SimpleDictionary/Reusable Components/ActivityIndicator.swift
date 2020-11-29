//
//  ActivityIndicator.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-28.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
