//
//  BindingUtils.swift
//  state.arch
//
//  Created by Matteo Battistini on 18/12/22.
//

import SwiftUI

func binding<T>(_ value: T, set: @escaping (T) -> Void ) -> Binding<T> {
  Binding(get: { value }) { set($0) }
}
