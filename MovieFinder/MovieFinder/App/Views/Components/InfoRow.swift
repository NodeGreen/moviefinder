//
//  InfoRow.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//


import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .fontWeight(.semibold)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .multilineTextAlignment(.leading)
        }
    }
}
