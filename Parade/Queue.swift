//
//  Queue.swift
//  Parade
//

import Foundation

/// Queue class.
public class Queue {
    /// Shared Queue.
    public static let shared: Queue = Queue.init(name: "Queue")
    
    /// Private OperationQueue.
    internal let queue: OperationQueue = OperationQueue.init()
    
    /// Total Operation count in queue.
    public var operationCount: Int {
        return self.queue.operationCount
    }
    
    /// Operations currently in queue.
    public var operations: [Operation] {
        return self.queue.operations
    }
    
    #if !os(Linux)
        /// The default service level to apply to operations executed using the queue.
        public var qualityOfService: QualityOfService {
            get {
                return self.queue.qualityOfService
            }
            set {
                self.queue.qualityOfService = newValue
            }
        }
    #endif
    
    /// Returns if the queue is executing or is in pause.
    /// Call `resume()` to make it running.
    /// Call `pause()` to make to pause it.
    public var isExecuting: Bool {
        return !self.queue.isSuspended
    }
    
    /// Define the max concurrent operation count.
    public var maxConcurrentOperationCount: Int {
        get {
            return self.queue.maxConcurrentOperationCount
        }
        set {
            self.queue.maxConcurrentOperationCount = newValue
        }
    }
    
    #if os(Linux)
        /// Creates a new queue.
        ///
        /// - Parameters:
        ///   - name: Custom queue name.
        ///   - maxConcurrentOperationCount: The max concurrent operation count.
        public init(name: String, maxConcurrentOperationCount: Int = Int.max) {
            self.queue.name = name
            self.maxConcurrentOperationCount = maxConcurrentOperationCount
        }
    #else
        /// Creates a new queue.
        ///
        /// - Parameters:
        ///   - name: Custom queue name.
        ///   - maxConcurrentOperationCount: The max concurrent operation count.
        ///   - qualityOfService: The default service level to apply to operations executed using the queue.
        public init(name: String, maxConcurrentOperationCount: Int = Int.max, qualityOfService: QualityOfService = .default) {
            self.queue.name = name
            self.maxConcurrentOperationCount = maxConcurrentOperationCount
            self.qualityOfService = qualityOfService
        }
    #endif
    
    /// Add an Operation to be executed asynchronously.
    ///
    /// - Parameter block: Block to be executed.
    public func addOperation(_ operation: @escaping () -> Void) {
        self.queue.addOperation(operation)
    }
    
    /// Add an Operation to be executed asynchronously.
    ///
    /// - Parameter operation: Operation to be executed.
    public func addOperation(_ operation: Operation) {
        self.queue.addOperation(operation)
    }
    
    /// Add an Array of chained Operations.
    ///
    /// Example:
    ///
    ///     [A, B, C] = A -> B -> C -> completionHandler.
    ///
    /// - Parameters:
    ///   - operations: Operations Array.
    ///   - completionHandler: Completion block to be exectuted when all Operations
    ///                        are finished.
    public func addChainedOperations(_ operations: [Operation], completionHandler: (() -> Void)? = nil) {
        for (index, operation) in operations.enumerated() {
            if index > 0 {
                operation.addDependency(operations[index - 1])
            }
            
            self.addOperation(operation)
        }
        
        guard let completionHandler = completionHandler else {
            return
        }
        
        let completionOperation = BlockOperation(block: completionHandler)
        if !operations.isEmpty {
            completionOperation.addDependency(operations[operations.count - 1])
        }
        self.addOperation(completionOperation)
    }
    
    /// Add an Array of chained Operations.
    ///
    /// Example:
    ///
    ///     [A, B, C] = A -> B -> C -> completionHandler.
    ///
    /// - Parameters:
    ///   - operations: Operations list.
    ///   - completionHandler: Completion block to be exectuted when all Operations
    ///                        are finished.
    public func addChainedOperations(_ operations: Operation..., completionHandler: (() -> Void)? = nil) {
        self.addChainedOperations(operations, completionHandler: completionHandler)
    }
    
    /// Cancel all Operations in queue.
    public func cancelAll() {
        self.queue.cancelAllOperations()
    }
    
    /// Pause the queue.
    public func pause() {
        self.queue.isSuspended = true
        
        for operation in self.queue.operations where operation is ConcurrentOperation {
            (operation as? ConcurrentOperation)?.pause()
        }
    }
    
    /// Resume the queue.
    public func resume() {
        self.queue.isSuspended = false
        
        for operation in self.queue.operations where operation is ConcurrentOperation {
            (operation as? ConcurrentOperation)?.resume()
        }
    }
    
    /// Blocks the current thread until all of the receiver’s queued and executing
    /// operations finish executing.
    public func waitUntilAllOperationsAreFinished() {
        self.queue.waitUntilAllOperationsAreFinished()
    }
}

public typealias Parade = Queue
