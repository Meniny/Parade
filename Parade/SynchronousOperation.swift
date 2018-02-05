//
//  SynchronousOperation.swift
//  Parade
//

import Foundation

/// It allows synchronous tasks, has a pause and resume states, can be easily added to a queue and can be created with a block.
public class SynchronousOperation: ConcurrentOperation {
    /// Private semaphore instance.
    let semaphore = Semaphore()
    
    /// Set the Operation as synchronous.
    public override var isAsynchronous: Bool {
        return false
    }
    
    /// Notify the completion of sync task and hence the completion of the operation.
    /// Must be called when the Operation is finished.
    public override func finish() {
        self.semaphore.continue()
    }
    
    /// Advises the operation object that it should stop executing its task.
    public override func cancel() {
        super.cancel()
        
        self.semaphore.continue()
    }
    
    /// Execute the Operation.
    /// If `executionBlock` is set, it will be executed and also `finish()` will be called.
    public override func execute() {
        super.execute()
        
        self.semaphore.wait()
    }
}
