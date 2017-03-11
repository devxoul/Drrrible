//
//  Observable+ActivityIndicator.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 10/03/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift
import RxSwiftUtilities

public typealias ActivityIndicatorFilter = (activityIndicator: ActivityIndicator, condition: Bool)

public extension ObservableConvertibleType {

  /// Filters the elements of an observable sequence based on an ActivityIndicator.
  ///
  ///     let loading = ActivityIndicator()
  ///     source
  ///         .filter(!loading)
  ///         .flatMap { ... }
  ///         .subscribe { ... }
  ///
  public func filter(_ activityIndicator: ActivityIndicator) -> Observable<Self.E> {
    return self.filter(activityIndicator == true)
  }

  public func filter(_ activityIndicatorFilter: ActivityIndicatorFilter) -> Observable<Self.E> {
    let (activityIndicator, condition) = activityIndicatorFilter
    return self.asObservable()
      .withLatestFrom(activityIndicator.asObservable().startWith(false)) { ($0, $1) }
      .filter { _, isLoading in isLoading == condition }
      .map { element, _ in element }
  }

}

prefix operator !

public prefix func ! (activityIndicator: ActivityIndicator) -> ActivityIndicatorFilter {
  return activityIndicator == false
}

public prefix func ! (activityIndicatorFilter: ActivityIndicatorFilter) -> ActivityIndicatorFilter {
  return (activityIndicatorFilter.activityIndicator, !activityIndicatorFilter.condition)
}

func == (activityIndicator: ActivityIndicator, condition: Bool) -> ActivityIndicatorFilter {
  return (activityIndicator, condition)
}
