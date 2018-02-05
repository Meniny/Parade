//
//  ConcurrentOperation.swift
//  Parade
//

import Foundation

/// It allows asynchronous tasks, has a pause and resume states, can be easily added to a queue and can be created with a block.
open class ConcurrentOperation: Operation {
    /// Operation's execution block.
    public var executionBlock: (() -> Void)?
    
    /// Creates the Operation with an execution block.
    ///
    /// - Parameter executionBlock: Execution block.
    public init(executionBlock: (() -> Void)? = nil) {
        super.init()
        self.executionBlock = executionBlock
    }
    
    /// Set the Operation as asynchronous.
    open override var isAsynchronous: Bool {
        return true
    }
    
    /// Set if the Operation is executing.
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    /// Set if the Operation is executing.
    open override var isExecuting: Bool {
        return _executing
    }
    
    /// Set if the Operation is finished.
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    /// Set if the Operation is finished.
    open override var isFinished: Bool {
        return _finished
    }
    
    /// Start the Operation.
    open override func start() {
        _executing = true
        execute()
    }
    
    /// Execute the Operation.
    /// If `executionBlock` is set, it will be executed and also `finish()` will be called.
    open func execute() {
        if let executionBlock = executionBlock {
            executionBlock()
            self.finish()
        }
    }
    
    /// Notify the completion of async task and hence the completion of the operation.
    /// Must be called when the Operation is finished.
    public func finish() {
        _executing = false
        _finished = true
    }
    
    /// Pause the current Operation, if it's supported.
    /// Must be overridend by subclass to get a custom pause action.
    open func pause() {}
    
    /// Resume the current Operation, if it's supported.
    /// Must be overridend by subclass to get a custom resume action.
    open func resume() {}
    
    /// Adds the Operation to `shared` Queue.
    public func addToSharedQueue() {
        Queue.shared.addOperation(self)
    }
    
    /// Adds the Operation to the custom queue.
    ///
    /// - Parameter queue: Custom queue where the Operation will be added.
    public func addToQueue(_ queue: Queue) {
        queue.addOperation(self)
    }
}
