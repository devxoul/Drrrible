//
//  Stub.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 22/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import Then

private typealias TypeName = String
private typealias FunctionAddress = Int
private typealias Function = Any

public protocol AnyExecution {
}

public struct Execution<A, R>: AnyExecution {
  public let arguments: A
  public let result: R
}

private var allStubs: [TypeName: [FunctionAddress: Function]] = [:]
private var allExecutions: [TypeName: [FunctionAddress: [AnyExecution]]] = [:]

public protocol Stub: Then {
}

public extension Stub {
  private static var typeName: String {
    return String(describing: self)
  }
  private var typeName: String {
    return String(describing: type(of: self))
  }


  // MARK: Stub

  public func stub<R>(_ f: () -> R, with closure: @escaping () -> R) {
    self._stub(f, with: closure)
  }

  public func stub<A, R>(_ f: (A) -> R, with closure: @escaping (A) -> R) {
    self._stub(f, with: closure)
  }

  private func _stub<A, R>(_ f: (A) -> R, with closure: @escaping (A) -> R) {
    var stubs = allStubs[self.typeName] ?? [:]
    let address = peekFunc(f).fp
    stubs[address] = closure
    allStubs[typeName] = stubs
  }


  // MARK: Call

  public func call<R>(_ f: () -> R) -> R {
    return self._call(f, args: ())
  }

  public func call<A, R>(_ f: (A) -> R, args: A) -> R {
    return self._call(f, args: args)
  }

  private func _call<A, R>(_ f: (A) -> R, args: A) -> R {
    let address = peekFunc(f).fp
    guard let closure = allStubs[self.typeName]?[address] as? (A) -> R else { fatalError() }
    let result = closure(args)
    var executions = allExecutions[self.typeName] ?? [:]
    executions[address] = (executions[address] ?? []) + [Execution<A, R>(arguments: args, result: result)]
    allExecutions[self.typeName] = executions
    return result
  }


  // MARK: Executions

  public func executions<R>(_ f: () -> R) -> [Execution<Void, R>] {
    return self._executions(f)
  }

  public func executions<A, R>(_ f: (A) -> R) -> [Execution<A, R>] {
    return self._executions(f)
  }

  private func _executions<A, R>(_ f: (A) -> R) -> [Execution<A, R>] {
    let address = peekFunc(f).fp
    guard let executions = allExecutions[self.typeName] else { return [] }
    return (executions[address] as? [Execution<A, R>]) ?? []
  }


  // MARK: Clear

  public static func clear() {
    allStubs.removeValue(forKey: self.typeName)
    allExecutions.removeValue(forKey: self.typeName)
  }
}

public func clearStubs() {
  allStubs.removeAll()
  allExecutions.removeAll()
}


/// Copyright (c) dankogai
///
/// - seealso: https://gist.github.com/dankogai/b03319ce427544beb5a4
private func peekFunc<A, R>(_ f: (A) -> R) -> (fp: Int, ctx: Int) {
  typealias IntInt = (Int, Int)
  let (_, lo) = unsafeBitCast(f, to: IntInt.self)
  let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
  let ptr = UnsafePointer<Int>(bitPattern: lo + offset)!
  return (ptr.pointee, ptr.successor().pointee)
}

/// Copyright (c) dankogai
///
/// - seealso: https://gist.github.com/dankogai/b03319ce427544beb5a4
private func === <A, R>(lhs: (A) -> R, rhs: (A) -> R) -> Bool {
  let (tl, tr) = (peekFunc(lhs), peekFunc(rhs))
  return tl.0 == tr.0 && tl.1 == tr.1
}
