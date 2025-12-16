import SwiftSyntax

enum AccessLevelModifier: String {
    case `private`
    case `fileprivate`
    case `internal`
    case `package`
    case `public`
    case `open`
}

protocol AccessLevelSyntax {
    var modifiers: DeclModifierListSyntax { get }
}

extension StructDeclSyntax: AccessLevelSyntax {}
extension ClassDeclSyntax: AccessLevelSyntax {}

extension AccessLevelSyntax {
    var accessLevel: AccessLevelModifier? {
        modifiers.lazy
            .compactMap { AccessLevelModifier(rawValue: $0.name.text) }
            .first
    }
}
