import SwiftSyntax

extension TokenKind {
  var keyword: Keyword? {
    switch self {
    case let .keyword(keyword):
      keyword
    default:
      nil
    }
  }
}
