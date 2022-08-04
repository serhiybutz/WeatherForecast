import Combine

extension Publisher where Output == Never {

    func setOutputType<T>(to outputType: T.Type) -> Publishers.Map<Self, T> {

        map { _ -> T in }
    }
}
