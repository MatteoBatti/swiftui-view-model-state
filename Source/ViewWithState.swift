//
//  ViewWithState.swift
//  state.arch
//
//  Created by Matteo Battistini on 17/12/22.
//

import SwiftUI

struct ViewWithState<Content, ViewState, ViewModel>: View
where
Content: View,
ViewModel.ViewState: Equatable,
ViewModel: ObservableObject,
ViewModel: ViewModelWithState,
ViewState == ViewModel.ViewState
{
  
  @ObservedObject var viewModel: ViewModel
  let content: (ViewState) -> Content
  
  init(
    viewModel: ViewModel,
    removeDuplicates isDuplicate: @escaping (ViewState, ViewState) -> Bool = { $0 == $1 },
    @ViewBuilder content: @escaping (ViewState) -> Content
  ) {
    self.viewModel = viewModel
    self.content = content
    self.viewModel.isDuplicate = isDuplicate
  }
  
  var body: some View {
    #if DEBUG
    print("ViewState changed")
    dump(viewModel.viewState)
    #endif
    return self.content(viewModel.viewState)
  }
}
