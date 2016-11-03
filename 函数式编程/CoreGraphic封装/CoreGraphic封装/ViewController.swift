//
//  ViewController.swift
//  CoreGraphic封装
//
//  Created by ddn on 16/8/11.
//  Copyright © 2016年 张永俊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        view = YJDraw()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var count = 0
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        let view = self.view as! YJDraw
        switch count {
        case 0:
            
            let cities = [
                ("Shanghai", 14.01),
                ("Istanbul", 13.3),
                ("Moscow", 10.56),
                ("New York", 8.33),
                ("Berlin", 3.43)
            ]
            view.diagram = view.barGraph(cities)
            
        case 1:
            
            let blueSquare = square(side: 1).fill(.blueColor())
            let redSquare = square(side: 2).fill(.redColor())
            let greenCircle = circle(diameter: 1).fill(.greenColor())
            let example1 = blueSquare ||| redSquare ||| greenCircle
            
            view.diagram = example1
            
        case 2:
            let blueSquare = square(side: 1).fill(.blueColor())
            let redSquare = square(side: 2).fill(.redColor())
            let greenCircle = circle(diameter: 1).fill(.greenColor())
            let cyanCircle = circle(diameter: 1).fill(.cyanColor())
            
            let example2 = blueSquare ||| cyanCircle ||| redSquare ||| greenCircle
            
            view.diagram = example2
            
        default:
            break
        }
        
        count += 1
        if count > 2 {
            count = 0
        }
    }
}





