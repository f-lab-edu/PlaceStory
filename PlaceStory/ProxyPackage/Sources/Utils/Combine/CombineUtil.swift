//
//  File.swift
//  
//
//  Created by 최제환 on 2/21/24.
//

import Combine
import Foundation

public final class CurrentPublisher<Element>: Publisher {
    public typealias Output = Element
    public typealias Failure = Never
    
    let currentValueSubject: CurrentValueSubject<Output, Failure>
    
    public var currentValue: Element {
        return currentValueSubject.value
    }
    
    public init(_ currentValue: Element) {
        self.currentValueSubject = CurrentValueSubject<Element, Never>(currentValue)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Element == S.Input {
        currentValueSubject.receive(subscriber: subscriber)
    }
}
