//
//  ContentView.swift
//  state.arch
//
//  Created by Matteo Battistini on 20/11/22.
//

import SwiftUI
import SwiftUINavigation

struct ContentView: View {
  
  @ObservedObject var viewModel: CounterViewModel
  
  var body: some View {
    //ViewWithState(viewModel: viewModel, removeDuplicates: { $0.title == $1.title }) { viewState in
    ViewWithState(viewModel: viewModel) { viewState in
      NavigationStack {
        VStack {
          Text("\(viewState.title)")
            .font(.largeTitle)
          Text("\(viewState.count)")
            .font(.title)
        }
        .onTapGesture {
          viewModel.send(action: .increment)
        }
        .toolbar {
          ToolbarItem {
            Button("Sheet") {
              viewModel.send(action: .openDetail)
            }
          }
        }
        .sheet(unwrapping: binding(viewState.destination, set: { viewModel.send(action: .update(destination: $0)) })) { _ in
          NavigationStack {
            DestinationView()
              .toolbar {
                ToolbarItem {
                  Button("Close") {
                    viewModel.send(action: .closeDetail)
                  }
                }
              }
          }
        }
      }
    }
  }
}

struct DestinationView: View {
  
  var body: some View {
    Text("Destination")
  }
}

class CounterViewModel: BaseViewModelWithState<CounterViewModel.ViewState, CounterViewModel.ViewAction> {
  
  enum Destination {
    case detail
  }
  
  struct ViewState: Equatable {
    var count: Int = 3
    var title: String = "Tap Me"
    var destination: CounterViewModel.Destination?
  }
  
  enum ViewAction {
    case openDetail
    case closeDetail
    case increment
    case update(destination: CounterViewModel.Destination?)
  }
  
  override init(viewState: ViewState = ViewState()) {
    super.init(viewState: viewState)
  }
  
  
  override func send(action: ViewAction) {
    switch action {
    case .openDetail:
      self.viewState.destination = .detail
    case .closeDetail:
      self.viewState.destination = nil
    case .update(destination: let destination):
      self.viewState.destination = destination
    case .increment:
      if viewState.count == 5 {
        viewState.count = 5
      } else {
        viewState.count += 1
      }
    }
  }
}

