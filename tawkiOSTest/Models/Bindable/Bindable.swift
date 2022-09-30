//
//  Bindable.swift
//  MVVMBasicStructure
//
//  Created by Apple on 21/09/22.
//

import Foundation

class Bindable<T> {
    
    private var dispatch: DispatchSourceTimer?
    
    private var value: T? {
        didSet {
            dispatch?.cancel()
            dispatch = DispatchSource.makeTimerSource(queue: .main)
            dispatch?.schedule(deadline: .now() + 0.1)
            dispatch?.setEventHandler(handler: {
                guard let value = self.value else { return }
                self.observer.forEach {
                    $0(value)
                }
            })
            dispatch?.resume()
        }
    }
    
    func set(value: T) {
        self.value = value
    }
    
    private lazy var observer = [((T) -> Void)]()
    
    func bind(observer: @escaping (T) -> Void) {
        self.observer.append(observer)
    }
}

public final class Observable<Value> {
    
    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (Value) -> Void
    }
    
    private var observers = [Observer<Value>]()
    
    public var value: Value {
        didSet { notifyObservers() }
    }
    
    public init(_ value: Value) {
        self.value = value
    }
    
    public func observe(on observer: AnyObject, observerBlock: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(self.value)
    }
    
    public func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    private func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async { observer.block(self.value) }
        }
    }
}
