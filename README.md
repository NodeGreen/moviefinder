# MovieFinder

[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![iOS Version](https://img.shields.io/badge/iOS-18.4+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![Core Data](https://img.shields.io/badge/Persistence-Core%20Data-red.svg)](https://developer.apple.com/documentation/coredata)
[![OMDb API](https://img.shields.io/badge/API-OMDb-purple.svg)](http://www.omdbapi.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A modern iOS application built with SwiftUI that allows users to search for movies, view detailed information, and manage a personal favorites collection. This project demonstrates advanced iOS development patterns including Clean Architecture, MVVM pattern, dependency injection, comprehensive testing, and Core Data integration with the OMDb API.

## Features

| Feature | Description | Status |
|---------|-------------|--------|
| 🔍 **Movie Search** | Real-time movie search with OMDb API integration | ✅ |
| 📱 **Modern UI** | Clean SwiftUI interface with smooth animations | ✅ |
| 💾 **Favorites System** | Save and manage favorite movies locally | ✅ |
| 📋 **Movie Details** | Comprehensive movie information display | ✅ |
| 🏷️ **Recent Searches** | Quick access to previously searched terms | ✅ |
| 🔄 **Offline Storage** | Core Data persistence for favorites | ✅ |
| 🎯 **Smart Caching** | Intelligent search query caching system | ✅ |
| 🧪 **Comprehensive Testing** | Unit tests with mock implementations | ✅ |

## Architecture & Design Patterns

### Clean Architecture + MVVM
The application follows Clean Architecture principles with MVVM pattern and clear separation of concerns:

```
MovieFinder/
├── App/
│   ├── MovieFinderApp.swift        # App entry point
│   ├── Views/                      # UI Layer
│   │   ├── MainView.swift         # Tab-based navigation
│   │   ├── MovieSearchView.swift  # Search interface
│   │   ├── MovieDetailView.swift  # Movie details
│   │   ├── MyFavoritesView.swift  # Favorites management
│   │   └── Components/            # Reusable UI components
│   └── ViewModels/                # Presentation logic
│       ├── MovieSearchViewModel.swift
│       ├── MovieDetailViewModel.swift
│       └── MyFavoritesViewModel.swift
├── Core/
│   ├── Models/                    # Domain entities
│   │   ├── Movie.swift
│   │   ├── MovieDetail.swift
│   │   └── SearchResult.swift
│   ├── Networking/                # Network layer
│   │   ├── HTTP/                  # Generic HTTP client
│   │   └── Services/OMDb/         # OMDb API specific
│   ├── Persistence/               # Data persistence
│   │   ├── CoreDataService.swift
│   │   └── CoreDataRepository.swift
│   ├── Favorites/                 # Favorites domain
│   │   ├── Model/
│   │   └── Repository/
│   ├── Cache/                     # Caching system
│   └── Storage/                   # Key-value storage
└── Tests/                         # Comprehensive test suite
```

### Key Design Patterns

**Repository Pattern**
```swift
protocol FavoritesRepositoryProtocol {
    func getAll() -> [FavoriteMovie]
    func add(_ movie: FavoriteMovie)
    func remove(_ movie: FavoriteMovie)
    func isFavorite(_ id: String) -> Bool
}
```

**Dependency Injection**
```swift
init(apiClient: MovieAPIClientProtocol,
     cache: SearchCacheProtocol = SearchCache(),
     favoritesRepository: FavoritesRepositoryProtocol = FavoritesRepository())
```

**Protocol-Oriented Programming**
- Clean abstractions for networking (`HTTPClientProtocol`)
- Testable architecture with protocol-based design
- Mock implementations for testing

**Generic Repository Pattern**
```swift
final class CoreDataRepository<T: NSManagedObject>: CoreDataRepositoryProtocol {
    typealias Entity = T
    // Generic Core Data operations
}
```

## Core Data Integration

The app uses Core Data for persistent storage with a clean entity design:

```swift
@objc(FavoriteMovieEntity)
public class FavoriteMovieEntity: NSManagedObject {
    @NSManaged public var imdbID: String?
    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var poster: String?
    
    func toDomain() -> FavoriteMovie { }
    func fill(from movie: FavoriteMovie) { }
}
```

Features:
- Generic repository pattern for type-safe operations
- Domain entity mapping with Core Data entities
- In-memory context support for testing
- Automatic data synchronization

## API Integration

### OMDb API
The application integrates with the OMDb (Open Movie Database) API for movie data:

```swift
enum OMDbEndpoint: Endpoint {
    case search(query: String)
    case detail(imdbID: String)
    
    var queryItems: [URLQueryItem] {
        // Dynamic API key injection from Secrets.plist
    }
}
```

**API Features:**
- Movie search by title
- Detailed movie information retrieval
- Poster image loading with AsyncImage
- Error handling and user feedback

## Configuration & Security

### Secrets Management
The project uses a secure configuration system for API keys:

1. **Create `Secrets.plist`** in the project root:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
    <key>OMDB_API_KEY</key>
    <string>YOUR_API_KEY_HERE</string>
</dict>
</plist>
```

2. **API Key Access:**
```swift
extension Bundle {
    var omdbApiKey: String? {
        guard let path = self.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            return nil
        }
        return dict["OMDB_API_KEY"] as? String
    }
}
```

**Security Notes:**
- `Secrets.plist` is gitignored to prevent API key exposure
- Bundle extension provides secure access to configuration
- Fail-safe handling when API key is missing

## Testing

The project maintains comprehensive test coverage with a robust testing strategy:

### Test Structure
```
MovieFinderTests/
├── MovieSearchViewModelTests.swift  # Search functionality
├── SearchCacheTests.swift          # Caching system
└── Mocks/
    └── MockMovieAPIClient.swift    # API client mock
```

### Testing Approach
- **Unit Tests** for ViewModels with dependency injection
- **Mock Objects** for external API dependencies
- **Core Data Testing** with in-memory persistent store
- **Async Testing** for API operations
- **Cache Testing** for search query persistence

### Key Test Cases
```swift
@MainActor func test_search_success_returnsMovies()
@MainActor func test_search_failure_setsErrorMessage()
@MainActor func test_fetchMovieDetail_success_setsMovieDetail()
func test_saves_most_recent_first_and_removes_duplicates()
func test_limits_to_maximum_of_5_queries()
```

## Technical Specifications

- **Language**: Swift 5.0
- **UI Framework**: SwiftUI
- **Architecture**: Clean Architecture + MVVM
- **Data Persistence**: Core Data
- **Reactive Programming**: Combine with @Published
- **Networking**: URLSession with custom HTTP client
- **Testing Framework**: XCTest with XCTestExpectation
- **Minimum iOS Version**: 18.4+
- **Xcode Version**: 16.3+

## Installation & Setup

### Prerequisites
- Xcode 16.3+
- iOS 18.4+ (for device testing)
- OMDb API key (free registration at [omdbapi.com](http://www.omdbapi.com/))

### Setup Instructions

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/moviefinder.git
cd moviefinder
```

2. **Configure API Key**
   - Get your free API key from [OMDb API](http://www.omdbapi.com/apikey.aspx)
   - Create `Secrets.plist` in the project root:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
    <key>OMDB_API_KEY</key>
    <string>YOUR_ACTUAL_API_KEY_HERE</string>
</dict>
</plist>
```

3. **Open in Xcode**
```bash
open MovieFinder.xcodeproj
```

4. **Build and Run**
   - Select your target device or simulator
   - Press Cmd + R to build and run
   - For testing: Press Cmd + U

## Core Components

### Search System
- **Real-time search** with debouncing
- **Recent searches** with intelligent caching (max 5 items)
- **Duplicate removal** and ordering by recency
- **Empty state handling** with user-friendly messages

### Favorites Management
- **Add/Remove favorites** with immediate UI feedback
- **Persistent storage** using Core Data
- **Synchronization** between search and favorites views
- **Heart icon animation** for user interaction feedback

### Networking Layer
- **Generic HTTP client** for reusable API calls
- **Protocol-based design** for easy testing and mocking
- **Error handling** with user-friendly messages
- **Response decoding** with custom decoder protocols

## Future Enhancements

- [ ] **Watchlist Feature**: Separate watchlist from favorites
- [ ] **Movie Ratings**: Personal rating system for watched movies
- [ ] **Advanced Search**: Filter by year, genre, director
- [ ] **Offline Mode**: Cache movie details for offline viewing
- [ ] **Share Movies**: Share movie information with friends
- [ ] **Dark Mode**: Enhanced dark mode support
- [ ] **iPad Support**: Optimized layout for larger screens
- [ ] **Widget**: iOS widget for quick favorites access

## API Reference

### OMDb API Endpoints Used
- **Search**: `GET /?s={query}&apikey={key}`
- **Movie Details**: `GET /?i={imdbID}&apikey={key}`

### Response Models
```swift
struct Movie: Codable, Identifiable {
    let title: String
    let year: String
    let poster: String
    let imdbID: String
}

struct MovieDetail: Codable {
    let title: String
    let year: String
    let genre: String
    let plot: String
    let director: String
    let imdbRating: String
    let poster: String
}
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Swift API Design Guidelines
- Maintain test coverage for new features
- Use protocol-oriented programming where applicable
- Write clear, self-documenting code
- Add appropriate error handling

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [OMDb API](http://www.omdbapi.com/) for providing free movie data
- Apple for SwiftUI and Core Data frameworks
- The iOS development community for best practices and patterns

---

**MovieFinder** - Discover, explore, and collect your favorite movies with a modern iOS experience.
