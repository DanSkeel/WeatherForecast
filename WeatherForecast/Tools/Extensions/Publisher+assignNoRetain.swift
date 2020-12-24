//
//  Publisher+assignNoRetain.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 29.11.2020.
//

import Combine

extension Publisher where Self.Failure == Never {
  
  /// Method that allows you to use `assign(to:on:)` with `self` avoiding retain cycle
  ///
  /// See https://forums.swift.org/t/does-assign-to-produce-memory-leaks/29546
  public func assignNoRetain<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
                                   on object: Root) -> AnyCancellable where Root: AnyObject {
    sink { [weak object] value in
      guard let object = object else { return }
      _ = Just(value).assign(to: keyPath, on: object)
    }
  }
}
