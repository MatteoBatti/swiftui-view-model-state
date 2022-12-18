//
//  ViewModelWithState.swift
//  state.arch
//
//  Created by Matteo Battistini on 17/12/22.
//

protocol ViewModelWithState {
  associatedtype ViewState
  associatedtype ViewAction
  var viewState: ViewState { get set }
  var isDuplicate: (ViewState, ViewState) -> Bool {get set}
  func send(action: ViewAction) -> Void
}
