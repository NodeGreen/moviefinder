//
//  SearchBar.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search..."
    var onSubmit: () -> Void
    
    @State private var isValid = true
    @State private var validationMessage = ""
    
    private let maxLength = 100
    private let minLength = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                    .onChange(of: text) { _, newValue in
                        validateAndSanitizeInput(newValue)
                    }
                    .onSubmit {
                        if isValid && !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onSubmit()
                        }
                    }

                Button(action: {
                    if isValid && !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        onSubmit()
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(isValid && !text.isEmpty ? .blue : .gray)
                        .padding(.horizontal)
                }
                .disabled(!isValid || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            if !isValid && !validationMessage.isEmpty {
                Text(validationMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private func validateAndSanitizeInput(_ input: String) {
        let sanitized = sanitizeInput(input)
        
        if sanitized != input {
            text = sanitized
        }
        
        let validation = validateInput(sanitized)
        isValid = validation.isValid
        validationMessage = validation.message
    }
    
    private func sanitizeInput(_ input: String) -> String {
        var sanitized = input
        
        // Limita la lunghezza
        if sanitized.count > maxLength {
            sanitized = String(sanitized.prefix(maxLength))
        }
        
        // Rimuovi caratteri non consentiti (mantieni solo lettere, numeri, spazi e alcuni simboli comuni)
        let allowedCharacters = CharacterSet.alphanumerics
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: ".,!?'-:()"))
        
        sanitized = sanitized.components(separatedBy: allowedCharacters.inverted).joined()
        
        // Rimuovi spazi multipli consecutivi
        sanitized = sanitized.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        )
        
        return sanitized
    }
    
    private func validateInput(_ input: String) -> (isValid: Bool, message: String) {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Input vuoto è tecnicamente valido (ma non cercabile)
        if trimmed.isEmpty {
            return (true, "")
        }
        
        // Troppo corto
        if trimmed.count < minLength {
            return (false, "Search must be at least \(minLength) character")
        }
        
        // Troppo lungo
        if trimmed.count > maxLength {
            return (false, "Search cannot exceed \(maxLength) characters")
        }
        
        // Solo spazi
        if input.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "Search cannot contain only spaces")
        }
        
        // Pattern sospetti (troppi caratteri speciali consecutivi)
        let specialCharPattern = "[.,!?'-:()]{3,}"
        if input.range(of: specialCharPattern, options: .regularExpression) != nil {
            return (false, "Too many special characters")
        }
        
        return (true, "")
    }
}
