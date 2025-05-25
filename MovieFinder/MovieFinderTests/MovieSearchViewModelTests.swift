//
//  MovieSearchViewModelTests.swift
//  MovieFinderTests
//
//  Created by Endo on 25/05/25.
//

import XCTest
@testable import MovieFinder

final class MovieSearchViewModelTests: XCTestCase {

    @MainActor func test_search_success_returnsMovies() {
        let mock = MockMovieAPIClient()
        let expectedMovies = [
            Movie(title: "Interstellar", year: "2014", poster: "", imdbID: "tt0816692"),
            Movie(title: "Inception", year: "2010", poster: "", imdbID: "tt1375666")
        ]
        mock.searchResultToReturn = .success(expectedMovies)

        let viewModel = MovieSearchViewModel(apiClient: mock)
        viewModel.query = "Christopher Nolan"

        let expectation = XCTestExpectation(description: "Search should return movies")
        
        viewModel.search()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(viewModel.movies.count, 2)
            XCTAssertEqual(viewModel.movies[0].title, "Interstellar")
            XCTAssertNil(viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    @MainActor func test_search_failure_setsErrorMessage() {
        let mock = MockMovieAPIClient()
        mock.searchResultToReturn = .failure(NSError(domain: "Test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"]))

        let viewModel = MovieSearchViewModel(apiClient: mock)
        viewModel.query = "Nonexistent"

        let expectation = XCTestExpectation(description: "Search should fail")

        viewModel.search()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(viewModel.movies.isEmpty)
            XCTAssertEqual(viewModel.errorMessage, "Test error")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    @MainActor func test_emptyQuery_clearsMoviesAndDoesNotCallAPI() {
        let mock = MockMovieAPIClient()
        let viewModel = MovieSearchViewModel(apiClient: mock)
        viewModel.query = "     "

        viewModel.search()

        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    @MainActor func test_fetchMovieDetail_success_setsMovieDetail() {
        let mock = MockMovieAPIClient()
        mock.detailResultToReturn = .success(
            MovieDetail(
                title: "Inception",
                year: "2010",
                genre: "Action, Sci-Fi",
                plot: "A mind-bending thriller",
                director: "Christopher Nolan",
                imdbRating: "8.8",
                poster: "https://example.com/poster.jpg"
            )
        )

        let viewModel = MovieDetailViewModel(imdbID: "tt1375666", apiClient: mock)

        let expectation = XCTestExpectation(description: "Movie detail loaded")

        viewModel.fetch()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(viewModel.movieDetail?.title, "Inception")
            XCTAssertEqual(viewModel.movieDetail?.director, "Christopher Nolan")
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.isLoading)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    @MainActor func test_fetchMovieDetail_failure_setsErrorMessage() {
        let mock = MockMovieAPIClient()
        mock.detailResultToReturn = .failure(MockMovieAPIClient.MockError.unset)

        let viewModel = MovieDetailViewModel(imdbID: "invalid", apiClient: mock)

        let expectation = XCTestExpectation(description: "Movie detail failed")

        viewModel.fetch()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(viewModel.movieDetail)
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.isLoading)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}

