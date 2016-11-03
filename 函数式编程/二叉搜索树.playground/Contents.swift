//: Playground - noun: a place where people can play

import UIKit

//递归 / 间接(Indirect)类型
//间接类型是 Swift 2.0 新增的一个类型。 它们允许将枚举中一个 case 的关联值再次定义为枚举。

//MARK: 定义
indirect enum BinarySearchTree<Element: Comparable> {
    case leaf
    case node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}

//MARK: 构造器
extension BinarySearchTree {
    /**空树*/
    init() {
        self = .leaf
    }
    
    /**具有单独值的树*/
    init(_ value: Element) {
        self = .node(.leaf, value, .leaf)
    }
}

//MARK: 计算属性
extension BinarySearchTree {
    /**计算一棵树中存值的个数*/
    var count: Int {
        switch self {
        case .leaf:
            return 0
        case let .node(left, _, right):
            return 1 + left.count + right.count
        }
    }
    
    /**获取树中存储的所有值*/
    var elements: [Element] {
        switch self {
        case .leaf:
            return []
        case let .node(left, x, right):
            return left.elements + [x] + right.elements
        }
    }
    
    /**检查一棵树是否为空树*/
    var isEmpty: Bool {
        if case .leaf = self {
            return true
        }
        return false
    }
    
    /**检查是不是二叉搜索树*/
    var isBST: Bool {
        switch self {
        case .leaf:
            return true
        case let .node(left, x, right):
            return left.elements.all{$0 < x}
                && right.elements.all{$0 > x}
                && left.isBST
                && right.isBST
        }
    }
}

// MARK: - 方法
extension BinarySearchTree {
    /**判断一个元素是否在树中*/
    func contains(x: Element) -> Bool {
        switch self {
        case .leaf:
            return false
        case let .node(_, y, _) where x == y:
            return true
        case let .node(left, y, _) where x < y:
            return left.contains(x)
        case let .node(_, y, right) where x > y:
            return right.contains(x)
        default:
            fatalError("the impossible occurred")
        }
    }
    
    /**插入元素*/
    mutating func insert(x: Element) {
        switch self {
        case .leaf:
            self = BinarySearchTree(x)
        case .node(var left, let y, var right):
            if x < y {left.insert(x)}
            else if x > y {right.insert(x)}
            else {self = .node(left, y, right)}
        }
    }
}

// MARK: 当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后被执行，我们称该闭包从函数中逃逸。当你定义接受闭包作为参数的函数时，可以在参数名之前标注@noescape,用来指明这个闭包是不允许“逃逸”出这个函数的。
//将闭包标注@noescape能使编译器知道这个闭包的生命周期
//注：闭包只能在函数体中被执行，不能脱离函数体执行，将闭包标注为@noescape使你能在闭包中隐式的引用self
extension SequenceType {
    /**检查一个数组中的元素是否都符合某个条件*/
    func all(@noescape predicate: Generator.Element -> Bool) -> Bool {
        for x in self where !predicate(x) {
            return false
        }
        return true
    }
}







