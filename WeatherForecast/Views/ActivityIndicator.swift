//
//  ActivityIndicator.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 24.12.2020.
//

import Foundation
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
  
  func makeUIView(context: UIViewRepresentableContext<Self>) -> UIActivityIndicatorView {
    let view = UIActivityIndicatorView()
    view.style = .large
    view.startAnimating()
    return view
  }
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Self>) {}
}
