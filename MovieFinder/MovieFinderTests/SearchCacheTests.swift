//
//  SearchCacheTests.swift
//  MovieFinderTests
//
//  Created by Endo on 25/05/25.
//

import XCTest
@testable import MovieFinder

final class SearchCacheTests: XCTestCase {

    func test_save_and_load_queries() {
        let mockStore = MockKeyValueStore()
        let cache = SearchCache(store: mockStore)

        cache.save("Interstellar")
        cache.save("Inception")

        let queries = cache.load()
        XCTAssertEqual(queries.count, 2)
        XCTAssertEqual(queries.first, "Inception")
    }

    func test_saves_most_recent_first_and_removes_duplicates() {
        let mockStore = MockKeyValueStore()
        let cache = SearchCache(store: mockStore)

        cache.save("Dune")
        cache.save("Inception")
        cache.save("Dune")

        let queries = cache.load()
        XCTAssertEqual(queries.count, 2)
        XCTAssertEqual(queries.first, "Dune")
    }

    func test_limits_to_maximum_of_5_queries() {
        let mockStore = MockKeyValueStore()
        let cache = SearchCache(store: mockStore)

        for title in ["1", "2", "3", "4", "5", "6", "7"] {
            cache.save(title)
        }

        let queries = cache.load()
        XCTAssertEqual(queries.count, 5)
        XCTAssertEqual(queries, ["7", "6", "5", "4", "3"])
    }
}
