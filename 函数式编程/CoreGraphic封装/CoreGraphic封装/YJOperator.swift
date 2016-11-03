//
//  YJOperator.swift
//  CoreGraphic封装
//
//  Created by ddn on 16/8/12.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

func * (l: CGFloat, r: CGSize) -> CGSize {
    return CGSize(width: l * r.width, height: l * r.height)
}

func * (l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width * r.width, height: l.height * r.height)
}

func / (l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width / r.width, height: l.height / r.height)
}

func - (l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width - r.width, height: l.height - r.height)
}

func - (l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x - r.x, y: l.y - r.y)
}

func + (l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width + r.width, height: l.height + r.height)
}

func + (l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x + r.x, y: l.y + r.y)
}