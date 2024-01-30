//
//  MultiScreenSubView.swift
//  MyAppToto1
//
//  Created by 岩田嘉吉 on 2017/06/25.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//

import Cocoa

struct MultiScreenSubViewControl {
    var sample1:Array<Int> = Array<Int>() // all
    var sample2:Array<Int> = Array<Int>() // gaito
    var frequency1:Array<Int> = Array<Int>()
    var frequency2:Array<Int> = Array<Int>()
    var bar1 = [[Int]]()
    var bar2 = [[Int]]()
    var xPosMiddle = Int()
    var xPosTop = Int()
    var xPosOver = Int()
    var xPosTopValue = Int()
    var yPosMiddle = Int()
    var yPosTop = Int()
    var yPosOver = Int()
    var yPosTopValue = Int()
    var prize = Int()
    var goDraw = Int()
    
    init(sample1:Array<Int>,sample2:Array<Int>,frequency1:Array<Int>,frequency2:Array<Int>,bar1:[[Int]],bar2:[[Int]],xPosMiddle:Int,xPosTop: Int,xPosOver: Int,xPosTopValue: Int,yPosMiddle:Int,yPosTop: Int,yPosOver: Int,yPosTopValue: Int,prize:Int,goDraw: Int){
        self.sample1 = sample1
        self.sample2 = sample2
        self.frequency1 = frequency1
        self.frequency2 = frequency2
        self.bar1 = bar1
        self.bar2 = bar2
        self.xPosMiddle = xPosMiddle
        self.xPosTop = xPosTop
        self.xPosOver = xPosOver
        self.xPosTopValue = xPosTopValue
        self.yPosMiddle = yPosMiddle
        self.yPosTop = yPosTop
        self.yPosOver = yPosOver
        self.yPosTopValue = yPosTopValue
        self.prize = prize
        self.goDraw = goDraw
    }
    
    mutating func reset() {
        sample1 = Array<Int>(repeating: 0,count:1)
        sample2 = Array<Int>(repeating: 0,count:1)
        frequency1 = Array<Int>(repeating: 0,count:360)
        frequency2 = Array<Int>(repeating: 0,count:360)
        bar1 = [[Int]]()
        bar2 = [[Int]]()
        xPosMiddle = 0
        xPosTop = 340
        xPosOver = 360
        xPosTopValue = 0
        yPosMiddle = 0
        yPosTop = 200
        yPosOver = 240
        yPosTopValue = 0
        prize = 0
        goDraw = 0
    }
    
}

var multiView = MultiScreenSubViewControl(sample1: Array<Int>(repeating: 0,count:1),sample2: Array<Int>(repeating: 0,count:1),frequency1: Array<Int>(repeating: 0,count:360),frequency2: Array<Int>(repeating: 0,count:360),bar1: [[Int]](repeating: [Int](repeating: 0, count: 4),count: 360),bar2: [[Int]](repeating: [Int](repeating: 0, count: 4),count: 360),xPosMiddle:0 ,xPosTop: 340,xPosOver: 360,xPosTopValue:7000,yPosMiddle:0 ,yPosTop: 200,yPosOver: 240,yPosTopValue: 0,prize:0,goDraw: 0)

struct cd {
    static let erase = 0        //  消すこと、すなわち背景色に合わせること
    static let drawBarChart = 1 //  描画

}
// 360x240 の４角形を作成
let r = NSRect(x:360, y:240, width:multiView.xPosOver, height:multiView.yPosOver)

class MyView01: NSView {
    //与えらえた４角形を青色に塗り潰し、ビューフレーム全体に広げる
    override func draw(_ dirtyRect: NSRect) {
        if multiView.goDraw == cd.erase{
            let color = NSColor.windowBackgroundColor
            color.setFill()
            self.bounds.fill()
        }
        
        if multiView.goDraw == cd.drawBarChart {
            let blue = NSColor.gray
            blue.setFill()
            self.bounds.fill()
            
            let bp = NSBezierPath(ovalIn: NSInsetRect(self.bounds, 20,20))
            NSColor.white.setFill()
            bp.fill()

            var x1 = 0,x2 = 0
            var y1 = 0,y2 = 0
            //  MARK:抽出条件一等下限値の縦棒をセット
            let line = NSBezierPath()
            let rect = self.bounds
            if  managment.judge[cm.prize][cm.low] > 0{
                x1 = managment.judge[cm.prize][cm.low] * multiView.xPosTop / multiView.xPosTopValue
                y1 = 0
                x2 = managment.judge[cm.prize][cm.low] * multiView.xPosTop / multiView.xPosTopValue
                y2 = multiView.yPosOver - 5 //  微調整a
                line.move(to: iOSMakePoint(x: CGFloat(x1), y: CGFloat(y1), rect: rect))
                line.line(to: iOSMakePoint(x: CGFloat(x2), y: CGFloat(y2), rect: rect))
                NSColor.green.setStroke()
                line.lineWidth = 1.0
                line.stroke()
            }
            //  MARK:抽出条件一等上限値の縦棒をセット
            if  managment.judge[cm.prize][cm.high] > 0{
                x1 = managment.judge[cm.prize][cm.high] * multiView.xPosTop / multiView.xPosTopValue + 2
                x2 = managment.judge[cm.prize][cm.high] * multiView.xPosTop / multiView.xPosTopValue + 2
                if  x1 > multiView.xPosTop{
                    x1 = multiView.xPosTop + 2
                    x2 = multiView.xPosTop + 2
                }
                line.move(to: iOSMakePoint(x: CGFloat(x1), y: CGFloat(y1), rect: rect))
                line.line(to: iOSMakePoint(x: CGFloat(x2), y: CGFloat(y2), rect: rect))
                NSColor.green.setStroke()
                line.lineWidth = 1.0
                line.stroke()
            }
        
            //  MARK:一等賞金の縦棒を作図
            if multiView.prize > 0{
                let Path0 = NSBezierPath()
                Path0.lineWidth = 2.0
                NSColor.red.setStroke()
                let rect = self.bounds
                // 売上２億賞金7千万の例 (70_000_000/10_000)* 340       / 7000                   > 340
                if Int(multiView.prize / 10000) * multiView.xPosTop / multiView.xPosTopValue > multiView.xPosTop{
                    x1 = multiView.xPosTop + 12
                }else{
                    x1 = Int(multiView.prize / 10000) * multiView.xPosTop / multiView.xPosTopValue
                }
                x2 = x1
                y2 = multiView.yPosTop / multiView.yPosTopValue
                Path0.move(to: iOSMakePoint(x: CGFloat(x1), y: CGFloat(y1), rect: rect))
                Path0.line(to: iOSMakePoint(x: CGFloat(x2), y: CGFloat(y2), rect: rect))
                Path0.stroke()
            }
            //  MARK:圧縮前の棒を作図
            let Path1 = NSBezierPath()
            Path1.lineWidth = 1.0
            NSColor.cyan.setStroke()
            for barCell in multiView.bar1{
                let rect = self.bounds
                Path1.move(to: iOSMakePoint(x: CGFloat(barCell[0]), y: CGFloat(barCell[1]), rect: rect))
                Path1.line(to: iOSMakePoint(x: CGFloat(barCell[2]), y: CGFloat(barCell[3]), rect: rect))
                Path1.stroke()
            }
            //  MARK:圧縮後の棒を作図
            let Path3 = NSBezierPath()
            Path3.lineWidth = 1.0
            NSColor.blue.setStroke()
            for barCell in multiView.bar2{
                let rect = self.bounds
                Path3.move(to: iOSMakePoint(x: CGFloat(barCell[0]), y: CGFloat(barCell[1]), rect: rect))
                Path3.line(to: iOSMakePoint(x: CGFloat(barCell[2]), y: CGFloat(barCell[3]), rect: rect))
                Path3.stroke()
            }
        }
    }
    
    func iOSMakePoint(x:CGFloat, y:CGFloat, rect: NSRect) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}

