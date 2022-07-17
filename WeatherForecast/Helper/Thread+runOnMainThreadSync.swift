import Foundation

extension Thread {
    
    @discardableResult
    static func runOnMainThreadSync<T>(block: () -> T) -> T {

        var result: T
        if isMainThread {
            result = block()
        } else {
            result = DispatchQueue.main.sync(execute: block)
        }
        return result
    }
}
