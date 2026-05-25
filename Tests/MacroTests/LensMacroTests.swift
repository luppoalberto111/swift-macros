import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class LensMacroTests: XCTestCase {
  func testBasicStruct() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @Lens
        struct Person {
          var name: String
          var age: Int
        }
        """,
        expandedSource:
        """
        struct Person {
          var name: String
          var age: Int

          static let nameLens = Lens<Person, String>(
              get: { $0.name },
              set: { root, value in var copy = root; copy.name = value; return copy }
          )

          static let ageLens = Lens<Person, Int>(
              get: { $0.age },
              set: { root, value in var copy = root; copy.age = value; return copy }
          )
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testPublicStruct() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @Lens
        public struct Point {
          var x: Double
          var y: Double
        }
        """,
        expandedSource:
        """
        public struct Point {
          var x: Double
          var y: Double

          public static let xLens = Lens<Point, Double>(
              get: { $0.x },
              set: { root, value in var copy = root; copy.x = value; return copy }
          )

          public static let yLens = Lens<Point, Double>(
              get: { $0.y },
              set: { root, value in var copy = root; copy.y = value; return copy }
          )
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testSkipsLetProperties() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @Lens
        struct User {
          let id: String
          var name: String
        }
        """,
        expandedSource:
        """
        struct User {
          let id: String
          var name: String

          static let nameLens = Lens<User, String>(
              get: { $0.name },
              set: { root, value in var copy = root; copy.name = value; return copy }
          )
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testSkipsComputedProperties() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @Lens
        struct Rectangle {
          var width: Double
          var height: Double
          var area: Double { width * height }
        }
        """,
        expandedSource:
        """
        struct Rectangle {
          var width: Double
          var height: Double
          var area: Double { width * height }

          static let widthLens = Lens<Rectangle, Double>(
              get: { $0.width },
              set: { root, value in var copy = root; copy.width = value; return copy }
          )

          static let heightLens = Lens<Rectangle, Double>(
              get: { $0.height },
              set: { root, value in var copy = root; copy.height = value; return copy }
          )
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testOptionalProperty() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @Lens
        struct Profile {
          var username: String
          var bio: String?
        }
        """,
        expandedSource:
        """
        struct Profile {
          var username: String
          var bio: String?

          static let usernameLens = Lens<Profile, String>(
              get: { $0.username },
              set: { root, value in var copy = root; copy.username = value; return copy }
          )

          static let bioLens = Lens<Profile, String?>(
              get: { $0.bio },
              set: { root, value in var copy = root; copy.bio = value; return copy }
          )
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testOnlyWorksOnStructs() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @Lens
        class ViewModel {
          var title: String = ""
        }
        """,
        expandedSource:
        """
        class ViewModel {
          var title: String = ""
        }
        """,
        diagnostics: [
          DiagnosticSpec(message: "Lens can only be applied to structs", line: 1, column: 1)
        ],
        macros: testMacros
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }
}
