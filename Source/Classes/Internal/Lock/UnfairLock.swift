//
//  UnfairLock.swift
//  FSCollectionKit
//
//  Created by VincentLee on 2025/5/24.
//  Copyright © 2025 VincentLee. All rights reserved.
//

import Foundation
import os.lock

///
/// 基于 os_unfair_lock_s 封装的互斥锁
///
/// - Important:
///   - 不支持递归加锁
///
final class UnfairLock {
    
    private var unfairLock = os_unfair_lock_s()
    
    init() {}
    
    @inline(__always)
    func lock() {
        os_unfair_lock_lock(&unfairLock)
    }
    
    @inline(__always)
    func unlock() {
        os_unfair_lock_unlock(&unfairLock)
    }
    
    @discardableResult
    @inline(__always)
    func withLock<T>(_ block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
