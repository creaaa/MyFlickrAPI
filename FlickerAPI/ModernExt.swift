
import Foundation

protocol ExampleCompatible {
    associatedtype CompatibleType
    var ex: CompatibleType { get }
}

struct Example<Base> {
    let base: Base
}

struct ExampleWithSingleAT<Base, AssociatedType> {
    let base: Base
}

extension Array: ExampleCompatible {
    var ex: ExampleWithSingleAT<Array<Element>, Element> {
        return ExampleWithSingleAT(base: self)
    }
}

extension ExampleWithSingleAT where Base == Array<AssociatedType> {
    var random: AssociatedType? {
        guard !self.base.isEmpty else { return nil }
        let index = Int(arc4random_uniform(UInt32(self.base.count)))
        return self.base[index]
    }
}




