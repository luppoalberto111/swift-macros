import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AutoInitMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let declarationSyntax: AccessLevelSyntax = declaration.as(StructDeclSyntax.self) ?? declaration.as(ClassDeclSyntax.self) else {
            throw AutoInitError.wrongType
        }
        let properties = declaration.properties.compactMap { variable in
            let properties: [(name: String, type: String, isFunction: Bool, value: String?)]? = variable.bindings.compactMap { binding in
                guard
                    let name = binding.identifierText,
                    let type = binding.currentOrLastType,
                    !binding.isConstant(with: variable) && !binding.isComputed
                else { return nil }

                return (name: name, type: type.description, isFunction: binding.isFunction, value: binding.valueDescription ?? binding.nilAssignmentText)
            }
            return properties ?? []
        }
        .flatMap { $0 }

        let parameters =
            properties
            .map { "\($0.name): \($0.isFunction ? "@escaping " : "")\($0.type)\($0.value.map { "= \($0)" } ?? "")" }
            .joined(separator: ",\n")

        let assignments =
            properties
            .map { "self.\($0.name) = \($0.name)" }
            .joined(separator: "\n")

        let accessLevel = declarationSyntax.accessLevel?.rawValue

        return [
            """
            \(raw: accessLevel.map { $0 + " " } ?? "")init(
                \(raw: parameters)
            ) {
                \(raw: assignments)
            }
            """
        ]
    }
}

extension AutoInitMacro {
    enum AutoInitError: Error, CustomStringConvertible {
        case wrongType

        var description: String {
            switch self {
            case .wrongType: return "AutoInit can only be applied to structs and classes"
            }
        }
    }
}

extension PatternBindingListSyntax.Element {
    fileprivate var nilAssignmentText: String? { currentOrLastType.flatMap { $0.is(OptionalTypeSyntax.self) ? "nil" : nil } }
}
