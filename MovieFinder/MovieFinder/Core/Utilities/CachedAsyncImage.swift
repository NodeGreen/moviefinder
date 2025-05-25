//
//  CachedAsyncImage.swift
//  MovieFinder
//
//  Created by Endo on 25/05/25.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View, ErrorView: View>: View {
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    private let errorView: (Error) -> ErrorView
    
    @StateObject private var loader = ImageLoader()
    @State private var retryCount = 0
    private let maxRetries = 2
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder errorView: @escaping (Error) -> ErrorView
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
        self.errorView = errorView
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                content(Image(uiImage: image))
            } else if loader.isLoading {
                placeholder()
            } else if let error = loader.error {
                errorView(error)
            } else {
                placeholder()
            }
        }
        .onAppear {
            loader.load(from: url)
        }
        .onChange(of: url) { _, newURL in
            loader.load(from: newURL)
        }
        .onTapGesture(count: 2) {
            // Double tap per retry
            if loader.error != nil && retryCount < maxRetries {
                retryCount += 1
                loader.load(from: url)
            }
        }
    }
}

// MARK: - Convenience Initializers
extension CachedAsyncImage where Content == Image, Placeholder == ProgressView<EmptyView, EmptyView>, ErrorView == Image {
    init(url: URL?) {
        self.init(
            url: url,
            content: { $0 },
            placeholder: { ProgressView() },
            errorView: { _ in Image(systemName: "photo") }
        )
    }
}

extension CachedAsyncImage where Placeholder == ProgressView<EmptyView, EmptyView> {
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder errorView: @escaping (Error) -> ErrorView
    ) {
        self.init(
            url: url,
            content: content,
            placeholder: { ProgressView() },
            errorView: errorView
        )
    }
}
