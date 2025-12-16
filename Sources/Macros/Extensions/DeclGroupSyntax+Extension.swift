import SwiftSyntax

extension DeclGroupSyntax {
    var properties: [VariableDeclSyntax] {
        memberBlock.members.compactMap { $0.decl.as(VariableDeclSyntax.self) }
    }
}
