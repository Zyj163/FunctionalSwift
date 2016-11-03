//
//  YJDraw.swift
//  CoreGraphic封装
//
//  Created by ddn on 16/8/12.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

/*------------组合算子----------*/

infix operator ||| {associativity left}
/**
 *  左右
 */
func ||| (l: Diagram, r: Diagram) -> Diagram {
    return Diagram.beside(l, r)
}


infix operator --- {associativity left}
/**
 *  上下
 */
func --- (u: Diagram, d: Diagram) -> Diagram {
    return Diagram.below(u, d)
}

/**矩形*/
func rect(width width: CGFloat, height: CGFloat) -> Diagram {
    return .primitive(CGSize(width: width, height: height), .rectangle)
}
/**圆*/
func circle(diameter diameter: CGFloat) -> Diagram {
    return .primitive(CGSize(width: diameter, height: diameter), .ellipse)
}
/**文字*/
func text(theText: String, width: CGFloat, height: CGFloat) -> Diagram {
    return .primitive(CGSize(width: width, height: height), .text(theText))
}
/**正方形*/
func square(side side: CGFloat) -> Diagram {
    return rect(width: side, height: side)
}

/// 随机数
var random: CGFloat {
    return CGFloat(arc4random_uniform(256))
}

/**随机色*/
func randomColor() -> UIColor {
    return UIColor(red: random/255.0, green: random/255.0, blue: random/255.0, alpha: 1)
}

/*-----------容器视图------------*/
class YJDraw: UIView {

    var diagram: Diagram? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.yellowColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), diagram = diagram else {return}
        
        context.draw(bounds, diagram)
    }
    
    func hcat(diagrams: [Diagram]) -> Diagram {
        let empty: Diagram = rect(width: 0, height: 0)
        return diagrams.reduce(empty, combine: |||)
    }
    
    func barGraph(input: [(String, Double)]) -> Diagram {
        
        let values: [CGFloat] = input.map{CGFloat($0.1)}
        
        let nValues = values.normalize()
        
        let bars = hcat(nValues.map{rect(width: 1, height: 5 * $0).fill(randomColor()).alignBottom()})
        
        let labels = hcat(input.map{text($0.0, width: 1, height: 0.3).alignCenter()})
        
        return bars --- labels
    }
}

/*-------------核心结构-------------*/
enum Primitive {
    /**椭圆*/
    case ellipse
    /**矩形*/
    case rectangle
    /**文字*/
    case text(String)
//    /**图片*/
//    case image(UIImage)
//    /**自定义图形*/
//    case easy(UIBezierPath)
}

enum Attribute {
    case fillColor(UIColor)
}

indirect enum Diagram {
    /**指定尺寸*/
    case primitive(CGSize, Primitive)
    /**左右相邻*/
    case beside(Diagram, Diagram)
    /**上下相邻*/
    case below(Diagram, Diagram)
    /**填充颜色等属性*/
    case attributed(Attribute, Diagram)
    /**图表中较小部分对齐方式，比如CGVector(0.5, 0,5)代表居中，CGVector(0, 0.5)代表靠左水平居中*/
    case align(CGVector, Diagram)
    
    /// 当前尺寸
    var size: CGSize {
        switch self {
        case .primitive(let size, _):
            return size
        case .attributed(_, let x):
            return x.size
        case .beside(let left, let right):
            return CGSize(width: left.size.width + right.size.width, height: max(left.size.height, right.size.height))
        case .below(let up, let down):
            return CGSize(width: max(up.size.width, down.size.width), height: up.size.height + down.size.height)
        case .align(_, let x):
            return x.size
        }
    }
}

/*--------------扩展--------------*/
extension Diagram {
    
    func fill(color: UIColor) -> Diagram {
        return .attributed(.fillColor(color), self)
    }
    
    func alignTop() -> Diagram {
        return .align(CGVector(dx: 0.5, dy: 0), self)
    }
    
    func alignBottom() -> Diagram {
        return .align(CGVector(dx: 0.5, dy: 1), self)
    }
    
    func alignCenter() -> Diagram {
        return .align(CGVector(dx: 0.5, dy: 0.5), self)
    }
}

extension CGSize {
    //将self按照指定对齐方式vector，fit到指定rect中
    func fit(vector: CGVector, _ rect: CGRect) -> CGRect {
        let scaleSize = rect.size / self
        let scale = min(scaleSize.width, scaleSize.height)
        let size = scale * self
        let space = vector.size * (size - rect.size)
        return CGRect(origin: rect.origin - space.point, size: size)
    }
}

extension CGSize {
    var point: CGPoint {return CGPoint(x: width, y: height)}
}

extension CGVector {
    var point: CGPoint {return CGPoint(x: dx, y: dy)}
    var size: CGSize {return CGSize(width: dx, height: dy)}
}

extension CGRect {
    /**
     将一个rect分解为两个
     
     - parameter ratio: 比例
     - parameter edge:  分割选项
     
     - returns: 分解后的两个rect
     */
    func split(ratio: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let length = edge.isHorizontal ? width : height
        return divide(ratio * length, fromEdge: edge)
    }
}

extension CGRectEdge {
    var isHorizontal: Bool {
        return self == .MaxXEdge || self == .MinXEdge
    }
}

extension SequenceType where Generator.Element == CGFloat {
    //等比规范所有的值，并确保最大值等于一
    func normalize() -> [CGFloat] {
        let maxValue = reduce(0) {max($0, $1)}
        return map{$0 / maxValue}
    }
}

extension CGContext {
    //在指定边界bounds中绘制指定内容diagram
    func draw(bounds: CGRect, _ diagram: Diagram) {
        switch diagram {
        case .primitive(let size, .ellipse):
            let frame = size.fit(CGVector(dx: 0.5, dy: 0.5), bounds)
            CGContextFillEllipseInRect(self, frame)
            
        case .primitive(let size, .rectangle):
            let frame = size.fit(CGVector(dx: 0.5, dy: 0.5), bounds)
            CGContextFillRect(self, frame)
            
        case .primitive(let size, .text(let text)):
            let frame = size.fit(CGVector(dx: 0.5, dy: 0.5), bounds)
            let font = UIFont.systemFontOfSize(12)
            let attributes = [NSFontAttributeName : font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.drawInRect(frame)
            
        case .attributed(.fillColor(let color), let d):
            CGContextSaveGState(self)
            color.setFill()
            draw(bounds, d)
            CGContextRestoreGState(self)
            
        case .beside(let left, let right):
            let (lFrame, rFrame) = bounds.split(left.size.width / diagram.size.width, edge: .MinXEdge)
            draw(lFrame, left)
            draw(rFrame, right)
            
        case .below(let up, let down):
            let (uFrame, dFrame) = bounds.split(up.size.height / diagram.size.height, edge: .MinYEdge)
            draw(uFrame, up)
            draw(dFrame, down)
            
        case .align(let vec, let d):
            let frame = d.size.fit(vec, bounds)
            draw(frame, d)
            
        default:
            break
        }
    }
}



