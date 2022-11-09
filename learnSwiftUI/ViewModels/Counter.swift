//
//  Counter.swift
//  learnSwiftUI
//
//  Created by LAP14482 on 17/11/2021.
//


import SwiftUI
import Combine

class Counter: ObservableObject {
    
    @Published var currentCount = 0
    var destinationCount: Int
    var subscriber: AnyCancellable?
    
    init(from initialCount: Int, to destinationCount: Int) {
        self.currentCount = initialCount
        self.destinationCount = destinationCount
    }
    
    func count(completion: @escaping () -> Void) {
        
        let publisher = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
        
        subscriber = publisher.sink { _ in
            self.adjustCurrentCount(to: self.destinationCount, completion: completion)
        }
    }
    
    private func adjustCurrentCount(to endCount: Int, completion: @escaping () -> Void) {
        if currentCount > endCount {
            currentCount -= 1
        }
        else if currentCount < endCount {
            currentCount += 1
        }
        else {
            subscriber?.cancel()
            completion()
        }
    }
}
