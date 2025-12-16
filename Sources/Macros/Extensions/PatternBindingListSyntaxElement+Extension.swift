import SwiftSyntax

extension PatternBindingListSyntax.Element {
    var isComputed: Bool { accessorBlock?.leftBrace != nil }
    var isFunction: Bool {
        typeAnnotation?.type.is(FunctionTypeSyntax.self) == true
            || typeAnnotation?.type.children(viewMode: .all).contains { $0.is(FunctionTypeSyntax.self) } == true
    }
    var identifierText: String? { pattern.as(IdentifierPatternSyntax.self)?.identifier.text }
    var currentOrLastType: TypeSyntax? { typeAnnotation?.type ?? parent?.as(PatternBindingListSyntax.self)?.last?.typeAnnotation?.type }
    var valueDescription: String? { initializer?.value.description }

    func isConstant(with variable: VariableDeclSyntax) -> Bool {
        variable.bindingSpecifier.tokenKind == .keyword(.let) && valueDescription != nil
    }
}
