//: Playground - noun: a place where people can play

import UIKit


typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
    
    func inRange(range: Distance) -> Bool {
        return length <= range
    }
    
}

extension Position {
    func minus(p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    
    var length: Distance {
        return sqrt(x * x + y * y)
    }
}

struct Region {
    let lookup: Position -> Bool
    
    init(_ lookup: Position -> Bool) {
        self.lookup = lookup
    }
    
    ///获得一个圆区域
    init(_ radius: Distance, _ center: Position = Position(x: 0, y: 0)) {
        lookup = {$0.minus(center).inRange(radius)}
    }
    
    ///区域变换函数，按一定的偏移量移动一个区域
    func shift(offset: Position) -> Region {
        return Region({self.lookup($0.minus(offset))})
    }
    
    ///获得一个区域以外的区域
    func invert() -> Region {
        return Region({!self.lookup($0)})
    }
    
    ///交集
    func intersection(region: Region) -> Region {
        return Region({self.lookup($0) && region.lookup($0)})
    }
    
    ///并集
    func union(region: Region) -> Region {
        return Region({self.lookup($0) || region.lookup($0)})
    }
    
    func difference(minus: Region) -> Region {
        return intersection(minus.invert())
    }
    
}


struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
    
    func canSagelyEngageShip(target: Ship, friendly: Ship) -> Bool {
        
        return Region(firingRange)
            .difference(Region(unsafeRange))
            .shift(position)
            .difference(Region(friendly.unsafeRange)
                .shift(friendly.position))
            .lookup(target.position)
    }
}

let ship = Ship(position: Position(x: 0, y: 0), firingRange: 100, unsafeRange: 50)

let targetShip = Ship(position: Position(x: 40, y: 40), firingRange: 100, unsafeRange: 50)

let friendShip = Ship(position: Position(x: -10, y: -10), firingRange: 100, unsafeRange: 50)


ship.canSagelyEngageShip(targetShip, friendly: friendShip)
