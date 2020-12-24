//
//  ErrorView.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 24.12.2020.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    
    let error: Error
    
    var body: some View {
        
        guard let localizedError = self.error as? LocalizedError,
           let description = localizedError.errorDescription else {
            
            return AnyView(Text(error.localizedDescription))
        }
        
        return AnyView(viewForError(description: description,
                                    reason: localizedError.failureReason,
                                    recoverySuggestion: localizedError.recoverySuggestion))
    }
}

private extension ErrorView {
    
    func viewForError(description: String, reason: String?, recoverySuggestion: String?) -> some View {
        VStack(spacing: 20) {
            Text(description)
                .font(.title)
            
            reason.map { Text($0) }
            
            recoverySuggestion.map { Text($0) }
        }
    }
}
