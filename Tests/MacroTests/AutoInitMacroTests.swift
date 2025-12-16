import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class AutoInitMacroTests: XCTestCase {
  func testBasicStructWithRequiredProperties() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
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

          init(
              name: String,
              age: Int
          ) {
              self.name = name
              self.age = age
          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testStructWithOptionalProperties() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
        struct User {
          var name: String
          var email: String?
          var phone: String?
        }
        """,
        expandedSource:
        """
        struct User {
          var name: String
          var email: String?
          var phone: String?

          init(
              name: String,
              email: String? = nil,
              phone: String? = nil
          ) {
              self.name = name
              self.email = email
              self.phone = phone
          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testStructWithDefaultValues() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
        struct Settings {
          var isEnabled: Bool = true
          var count: Int = 0
          var name: String
        }
        """,
        expandedSource:
        """
        struct Settings {
          var isEnabled: Bool = true
          var count: Int = 0
          var name: String

          init(
              isEnabled: Bool = true,
              count: Int = 0,
              name: String
          ) {
              self.isEnabled = isEnabled
              self.count = count
              self.name = name
          }
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
        @AutoInit
        public struct Product {
          var id: String
          var price: Double
        }
        """,
        expandedSource:
        """
        public struct Product {
          var id: String
          var price: Double

          public init(
              id: String,
              price: Double
          ) {
              self.id = id
              self.price = price
          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testPrivateStruct() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
        private struct Internal {
          var value: Int
        }
        """,
        expandedSource:
        """
        private struct Internal {
          var value: Int

          private init(
              value: Int
          ) {
              self.value = value
          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testClassSupport() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
        class ViewModel {
          var title: String
          var isLoading: Bool
        }
        """,
        expandedSource:
        """
        class ViewModel {
          var title: String
          var isLoading: Bool

          init(
              title: String,
              isLoading: Bool
          ) {
              self.title = title
              self.isLoading = isLoading
          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testFunctionTypeProperties() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
        struct Handler {
          var onComplete: () -> Void
          var transform: (String) -> Int
        }
        """,
        expandedSource:
        """
        struct Handler {
          var onComplete: () -> Void
          var transform: (String) -> Int

          init(
              onComplete: @escaping () -> Void,
              transform: @escaping (String) -> Int
          ) {
              self.onComplete = onComplete
              self.transform = transform
          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testIgnoresComputedProperties() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
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

          init(
              width: Double,
              height: Double
          ) {
              self.width = width
              self.height = height
          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testIgnoresConstantsWithValues() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
        struct Config {
          let version = "1.0.0"
          var apiKey: String
        }
        """,
        expandedSource:
        """
        struct Config {
          let version = "1.0.0"
          var apiKey: String

          init(
              apiKey: String
          ) {
              self.apiKey = apiKey
          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testMixedProperties() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
        struct Complex {
          var name: String
          var count: Int = 10
          var callback: (() -> Void)?
          let constant = "fixed"
          var computed: String { name.uppercased() }
        }
        """,
        expandedSource:
        """
        struct Complex {
          var name: String
          var count: Int = 10
          var callback: (() -> Void)?
          let constant = "fixed"
          var computed: String { name.uppercased() }

          init(
              name: String,
              count: Int = 10,
              callback: (() -> Void)? = nil
          ) {
              self.name = name
              self.count = count
              self.callback = callback
          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testEmptyStruct() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
        struct Empty {
        }
        """,
        expandedSource:
        """
        struct Empty {

          init(

          ) {

          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testMacroOnlySupportsStructOrClass() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
        enum Status {
          case active
          case inactive
        }
        """,
        expandedSource:
        """
        enum Status {
          case active
          case inactive
        }
        """,
        diagnostics: [
          DiagnosticSpec(message: "AutoInit can only be applied to structs and classes", line: 1, column: 1)
        ],
        macros: testMacros
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testPublicClassWithMixedProperties() throws {
    #if canImport(Macros)
    assertMacroExpansion(
        """
        @AutoInit
        public class DataStore {
          var items: [String]
          var isReady: Bool = false
        }
        """,
        expandedSource:
        """
        public class DataStore {
          var items: [String]
          var isReady: Bool = false

          public init(
              items: [String],
              isReady: Bool = false
          ) {
              self.items = items
              self.isReady = isReady
          }
        }
        """,
        macros: testMacros,
        indentationWidth: .spaces(2)
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }
}
