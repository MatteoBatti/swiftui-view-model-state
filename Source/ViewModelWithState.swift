import SwiftUI

struct ContentView: View {
  
  @ObservedObject var viewModel: MyViewModel
  
  var body: some View {
    //ViewWithState(viewModel: viewModel, removeDuplicates: { $0.title == $1.title }) { viewState in
    ViewWithState(viewModel: viewModel) { viewState in
      VStack {
        Text("\(viewState.title)")
          .font(.largeTitle)
        Text("\(viewState.count)")
          .font(.title)
      }
      .onTapGesture {
        viewModel.increment()
      }
    }
  }
}

class MyViewModel: BaseViewModelWithState<MyViewModel.ViewState> {
  
  struct ViewState: Equatable {
    var count: Int = 3
    var title: String = "Tap Me"
  }
  
  override init(viewState: ViewState = ViewState()) {
    super.init(viewState: viewState)
  }
  
  func increment() {
    if viewState.count == 5 {
      viewState.count = 5
    } else {
      viewState.count += 1
    }
  }
}

protocol ViewModelViewState {
  associatedtype ViewState
  var viewState: ViewState { get set }
  var isDuplicate: (ViewState, ViewState) -> Bool {get set}
}

struct ViewWithState<Content, ViewState, ViewModel>: View
where
Content: View,
ViewModel.ViewState: Equatable,
ViewModel: ObservableObject,
ViewModel: ViewModelViewState,
ViewState == ViewModel.ViewState
{
  
  @ObservedObject var viewModel: ViewModel
  let content: (ViewState) -> Content
  
  init(
    viewModel: ViewModel,
    removeDuplicates isDuplicate: @escaping (ViewState, ViewState) -> Bool = { $0 == $1 },
    @ViewBuilder  content: @escaping (ViewState) -> Content
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

class BaseViewModelWithState<ViewState: Equatable>: ViewModelViewState, ObservableObject {
  
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
}

