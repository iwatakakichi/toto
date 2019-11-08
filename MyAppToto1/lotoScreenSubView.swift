//
//  lotoScreenSubView.swift
//  MyAppToto1
//
//  Created by 岩田嘉吉 on 2018/04/06.
//  Copyright © 2018年 岩田嘉吉. All rights reserved.
//

import Cocoa


struct lotoScreenSubViewControl {
    var goDraw = Int()
    var max = Int()
    
    init(goDraw: Int,max: Int){
        self.goDraw = goDraw
        self.max = max
    }

}

var lotoView = lotoScreenSubViewControl(goDraw: 0,max: 0)

struct ld {
    static let erase = 0        //  消すこと、すなわち背景色に合わせること
    static let goDrawBarChart = 1 //  bar描画
    static let goDrawDotChart = 2 //  dot描画

    // 360x240 の４角形を作成
    let r = NSRect(x:450, y:280, width:multiView.xPosOver, height:multiView.yPosOver)
    
}

class MyView02: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
 
        var gArray = [[Int]]()
        for cell in 0...lotoManage.distribution.count - 1 {
            if lotoManage.distribution[cell] != Array<Int>(repeating: 0,count: 3){
                gArray.append(lotoManage.distribution[cell])
            }
        }
        
        // Drawing code here.
        //  MARK: グラフを消去する
        if lotoView.goDraw == ld.erase{
            let color = NSColor.windowBackgroundColor
            color.setFill()
            self.bounds.fill()
        }
        //  MARK:   棒グラフを作図する
        if lotoView.goDraw == ld.goDrawBarChart {
            let blue = NSColor.gray
            blue.setFill()
            self.bounds.fill()
            
            let bp = NSBezierPath(ovalIn: NSInsetRect(self.bounds, 20,20))
            NSColor.white.setFill()
            bp.fill()
            gArray.sort { $0[1] > $1[1] }
            lotoView.max = gArray[0][1]
            gArray.sort { $0[0] < $1[0] }
            
            let langeX = 450
            let langeY = 280
            let stepX = (langeX - 10)  / 43
            let stepY = (langeY - 10) / lotoView.max
            
            //  MARK:すべて
            let line1 = NSBezierPath()
            line1.lineWidth = 1.0
            NSColor.cyan.setStroke()
            for i in 0...lotoManage.sizeOfloto - 1{
                let rect = self.bounds
                line1.move(to: iOSMakePoint(x: CGFloat(stepX * i + 10), y: CGFloat(10), rect: rect))
                line1.line(to: iOSMakePoint(x: CGFloat(stepX * i + 10), y: CGFloat(gArray[i][1] * stepY), rect: rect))
                line1.stroke()
            }
            //  MARK:直近
            let line2 = NSBezierPath()
            line2.lineWidth = 1.0
            NSColor.blue.setStroke()
            for i in 0...gArray.count - 1{
                let rect = self.bounds
                line2.move(to: iOSMakePoint(x: CGFloat(stepX * i + 10), y: CGFloat(10), rect: rect))
                line2.line(to: iOSMakePoint(x: CGFloat(stepX * i + 10), y: CGFloat(gArray[i][2] * stepY), rect: rect))
                line2.stroke()
            }
            //  MARK:目盛
            let line3 = NSBezierPath()
            line3.lineWidth = 1.0
            NSColor.red.setStroke()
            for i in 0...sizeOfLoto6 - 1{
                if i % 5 == 4{
                    let rect = self.bounds
                    line3.move(to: iOSMakePoint(x: CGFloat(stepX * i + 10), y: CGFloat(5), rect: rect))
                    line3.line(to: iOSMakePoint(x: CGFloat(stepX * i + 10), y: CGFloat(10), rect: rect))
                    line3.stroke()
                }
            }
        }
        //  MARK:   プロット図を作図する
        if lotoView.goDraw == ld.goDrawDotChart {
            var yMax = lotoManage.rakutenData.count
            if yMax > 44{
                yMax = 44
            }
            let blue = NSColor.gray
            blue.setFill()
            self.bounds.fill()
            
            let bp = NSBezierPath(ovalIn: NSInsetRect(self.bounds, 20,20))
            NSColor.white.setFill()
            bp.fill()
            let langeX = 450
            let langeY = 280
            let stepX = (langeX - 10) / sizeOfLoto6
            let stepY = (langeY - 10) / yMax
            
            let line1 = NSBezierPath()
            line1.lineWidth = 5.0
            NSColor.blue.setStroke()
            
            for i in 0...yMax - 1{
                for mark in 2...lotoManage.markOfloto + 1{
                    let rect = self.bounds
                    line1.move(to: iOSMakePoint(x: CGFloat(stepX * lotoManage.rakutenData[i][mark] - 10), y: CGFloat(260 - (i * stepY + 10)), rect: rect))
                    line1.line(to: iOSMakePoint(x: CGFloat(stepX * lotoManage.rakutenData[i][mark]), y: CGFloat(260 - (i * stepY + 10)), rect: rect))
                    line1.stroke()
                }
                
            }
            
            //  MARK:目盛
            let line3 = NSBezierPath()
            line3.lineWidth = 1.0
            NSColor.gridColor.setStroke()
            for i in 0...lotoManage.sizeOfloto - 1{
                if i % 5 == 4{
                    let rect = self.bounds
                    line3.move(to: iOSMakePoint(x: CGFloat(stepX * i + 10), y: CGFloat(5), rect: rect))
                    line3.line(to: iOSMakePoint(x: CGFloat(stepX * i + 10), y: CGFloat(255), rect: rect))
                    line3.stroke()
                }
            }
        }
      
    }
    
    func iOSMakePoint(x:CGFloat, y:CGFloat, rect: NSRect) -> CGPoint {
        return CGPoint(x: x, y: y)
        
    }
    
}
