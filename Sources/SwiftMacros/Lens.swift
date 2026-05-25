public struct Lens<Root, Value> {
    public let get: (Root) -> Value
    public let set: (Root, Value) -> Root

    public init(get: @escaping (Root) -> Value, set: @escaping (Root, Value) -> Root) {
        self.get = get
        self.set = set
    }
}
