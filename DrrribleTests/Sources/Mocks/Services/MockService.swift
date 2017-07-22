//
//  MockService.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 22/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

/// https://gist.github.com/dankogai/b03319ce427544beb5a4
private func peekFunc<A, R>(_ f: (A) -> R) -> (fp: Int, ctx: Int) {
  typealias IntInt = (Int, Int)
  let (_, lo) = unsafeBitCast(f, to: IntInt.self)
  let offset = MemoryLayout<Int>.size == 8 ? 16 : 12
  let ptr = UnsafePointer<Int>(bitPattern: lo + offset)!
  return (ptr.pointee, ptr.successor().pointee)
}

private func === <A, R>(lhs: (A) -> R, rhs: (A) -> R) -> Bool {
  let (tl, tr) = (peekFunc(lhs), peekFunc(rhs))
  return tl.0 == tr.0 && tl.1 == tr.1
}

private typealias Key = String
private var mocks: [Key: Any] = [:]
private var counts: [Key: Int] = [:]

protocol MockService {
}

extension MockService {
  var `Self`: Self.Type {
    return type(of: self)
  }

  func mock<R>(_ f: (Self) -> () -> R, with closure: @escaping () -> R) {
    let key = self.key(for: f)
    mocks[key] = closure
  }

  func mock<A, R>(_ f: (Self) -> (A) -> R, with closure: @escaping (A) -> R) {
    let key = self.key(for: f)
    mocks[key] = closure
  }

  func call<R>(_ f: (Self) -> () -> R) -> R {
    let key = self.key(for: f)
    guard let closure = mocks[key] as? () -> R else { fatalError() }
    let result = closure()
    counts[key] = (counts[key] ?? 0) + 1
    return result
  }

  func call<A, R>(_ f: (Self) -> (A) -> R, args: A) -> R {
    let key = self.key(for: f)
    guard let closure = mocks[key] as? (A) -> R else { fatalError() }
    let result = closure(args)
    counts[key] = (counts[key] ?? 0) + 1
    return result
  }

  func executionCount<R>(_ f: (Self) -> () -> R) -> Int {
    let key = self.key(for: f)
    return counts[key] ?? 0
  }

  func executionCount<A, R>(_ f: (Self) -> (A) -> R) -> Int {
    let key = self.key(for: f)
    return counts[key] ?? 0
  }

  static func clear() {
    mocks.keys
      .filter { $0.hasPrefix(String(describing: self)) }
      .forEach { mocks.removeValue(forKey: $0) }
    counts.keys
      .filter { $0.hasPrefix(String(describing: self)) }
      .forEach { counts.removeValue(forKey: $0) }
  }

  private func key<A, R>(for f: (Self) -> (A) -> R) -> Key {
    let name =  String(describing: type(of: self))
    let fp = peekFunc(f(self)).fp
    return "\(name)-\(fp)"
  }
}

func clearMocks() {
  mocks.removeAll()
  counts.removeAll()
}
