import Foundation
import SwiftUI

/// Base protocol for all ViewModels in the application
protocol BaseViewModel: ObservableObject {
    associatedtype State
    var state: State { get }
    func updateState(_ newState: State)
}

/// Base class for ViewModels with common functionality
class ViewModelBase<State>: ObservableObject, BaseViewModel {
    @Published var state: State
    
    init(initialState: State) {
        self.state = initialState
    }
    
    func updateState(_ newState: State) {
        self.state = newState
    }
}