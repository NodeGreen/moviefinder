//
//  InfoRow.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import SwiftUI

struct InfoRow: View {
    let iconName: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.blue)
                .frame(width: 24)
            
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
