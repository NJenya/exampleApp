//
//  Queue.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 11.03.2025.
//

import Foundation

final class Queue<T> {
    private var elements: [T] = []
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
    
    func enqueue(_ element: T) {
        elements.append(element)
    }
    
    func dequeue() -> T? {
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }
    
    func peek() -> T? {
        return elements.first
    }
    
    func removeAll() {
        elements.removeAll()
    }
}
