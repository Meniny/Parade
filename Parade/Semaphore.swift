//
//  Semaphore.swift
//  Parade
//

import Foundation
import Dispatch

/// DispatchSemaphore struct wrapper.
public struct Semaphore {
    /// Private DispatchSemaphore.
    private let semaphore: DispatchSemaphore
    
    /// Creates new counting semaphore with an initial value.
    /// Passing zero for the value is useful for when two threads need to reconcile
    /// the completion of a particular event. Passing a value greater than zero is
    /// useful for managing a finite pool of resources, where the pool size is equal
    /// to the value.
    ///
    /// - Parameter poolSize: The starting value for the semaphore.
    ///                       Passing a value less than zero will cause NULL to be returned.
    public init(poolSize: Int = 0) {
        self.semaphore = DispatchSemaphore(value: poolSize)
    }
    
    /// Wait for a `continue` function call.
    @discardableResult
    public func wait() -> DispatchTimeoutResult {
        return self.semaphore.wait(timeout: .distantFuture)
    }
    
    /// This function returns non-zero if a thread is woken. Otherwise, zero is returned.
    ///
    /// - Returns: Returns non-zero if a thread is woken. Otherwise, zero is returned.
    @discardableResult
    public func `continue`() -> Int {
        return self.semaphore.signal()
    }
}
