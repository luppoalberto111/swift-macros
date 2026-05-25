import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct LensMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw LensError.wrongType
        }

        let structName = structDecl.name.text
        let accessLevel = structDecl.accessLevel?.rawValue
        let prefix = accessLevel.map { $0 + " " } ?? ""

        return declaration.properties.flatMap { variable -> [DeclSyntax] in
            guard variable.bindingSpecifier.tokenKind != .keyword(.let) else { return [] }
            return variable.bindings.compactMap { binding -> DeclSyntax? in
                guard
                    let name = binding.identifierText,
                    let type = binding.currentOrLastType,
                    !binding.isComputed
                else { return nil }

                let typeStr = type.trimmedDescription
                return """
                \(raw: prefix)static let \(raw: name)Lens = Lens<\(raw: structName), \(raw: typeStr)>(
                    get: { $0.\(raw: name) },
                    set: { root, value in var copy = root; copy.\(raw: name) = value; return copy }
                )
                """
            }
        }
    }
}

extension LensMacro {
    enum LensError: Error, CustomStringConvertible {
        case wrongType

        var description: String {
            switch self {
            case .wrongType: return "Lens can only be applied to structs"
            }
        }
    }
}
