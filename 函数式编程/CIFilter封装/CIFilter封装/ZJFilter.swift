//
//  ZJFilter.swift
//  CIFilter封装
//
//  Created by ddn on 16/7/19.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import CoreImage
import UIKit

typealias Filter = CIImage -> CIImage

func blur(radius: Double) -> Filter {
    return {
        let parms = [kCIInputRadiusKey : radius,
                     kCIInputImageKey : $0]
        guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parms) else {fatalError()}
        guard let outputImage = filter.outputImage else {fatalError()}
        
        return outputImage
    }
}

func colorGenerator(color: UIColor) -> Filter {
    return {_ in 
        let c = CIColor(color: color)
        let parms = [kCIInputColorKey : c]
        guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parms) else {fatalError()}
        guard let outputImage = filter.outputImage else {fatalError()}
        
        return outputImage
    }
}


func compositeSourceOver(overlay: CIImage) -> Filter {
    return {
        let parms = [kCIInputBackgroundImageKey : $0,
                     kCIInputImageKey : overlay]
        guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parms) else {fatalError()}
        guard let outputImage = filter.outputImage else {fatalError()}
        let cropRect = $0.extent
        
        return outputImage.imageByCroppingToRect(cropRect)
    }
}


func colorOverlay(color: UIColor) -> Filter {
    return {
        let overlay = colorGenerator(color)($0)
        return compositeSourceOver(overlay)($0)
    }
}

//定义运算符
infix operator >>> {associativity left}

func >>> (filter1: Filter, filter2: Filter) -> Filter {
    return {filter2(filter1($0))}
}

//升级版
func >>> <A, B, C>(f: A -> B, g: B -> C) -> A -> C {
    return {g(f($0))}
}

//将任意的接受两个元素的元祖作为输入的函数进行柯里化(curry)处理，从而生成相应的柯里化版本
func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
    return {x in {y in f(x, y)}}
}














