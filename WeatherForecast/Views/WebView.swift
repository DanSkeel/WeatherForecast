//
//  WebView.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 27.12.2020.
//

import Foundation
import UIKit
import SwiftUI
import Combine
import WebKit

struct WebView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = true
       return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = Bundle.main.url(forResource: "Help", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
    
    class Coordinator : NSObject, WKNavigationDelegate {
        
    }
}
