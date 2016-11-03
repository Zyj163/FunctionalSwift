//: Playground - noun: a place where people can play

import UIKit

struct Trie<Element: Hashable> {
    let isElement: Bool
    let children: [Element : Trie]
    
    var elements: [[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map{[key] + $0}
        }
        return result
    }
    
    
    /**创建一个空的字典树*/
    init() {
        isElement = false
        children = [:]
    }
    
    
}
