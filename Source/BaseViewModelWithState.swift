//
//  BaseViewModelViewState.swift
//  state.arch
//
//  Created by Matteo Battistini on 17/12/22.
//
import Combine

class BaseViewModelWithState<ViewState: Equatable, ViewAction>: ViewModelWithState, ObservableObject {
  
  var isDuplicate: (ViewState, ViewState) -> Bool = { $0 == $1 }
  
  init(viewState: ViewState) {
    self.viewState = viewState
  }
  
  var viewState: ViewState {
    willSet {
      if !isDuplicate(newValue, viewState) {
        objectWillChange.send()
      }
    }
  }
  
  func send(action: ViewAction) {
    fatalError("unimplemented")
  }
}
