//
//  administratorLoto.swift
//  MyAppToto1
//
//  Created by 岩田嘉吉 on 2018/04/05.
//  Copyright © 2018年 岩田嘉吉. All rights reserved.
//

import Cocoa

/*
 ***** 管理者クラス
 */

struct Manager {
    var category:Int = 0    // 0.miniLoto 1.loto6 2.loto7
    var kaigo:Int = 0
    var drivingMode: Int = 0   //  0.idling 1.drive
    var keyboardMode: Int = 0   //  0.normal 1.frequentNumbers
    var counter: Int = 0
    var cpuTimeInterval: Double = 0
    var keyboard: Array<Int> = Array<Int>(repeating: 0,count:43)
    var layer = [[Int]](repeating: [Int](repeating: 0, count: 43),count: 2)
    var tab: Int = 0
    var myNumber = [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: 7),count: 4),count:3)   //  category,い、ろ、は、に
    var popUpButton: Int = 0
    var distribution: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 43) //  番号、すべて、直近
    var conditionsSet = [[Int]](repeating: [Int](repeating: 0, count: 6),count: 3) // [category] [0.よく出る数字1.前回当選番号2.連続した数字4.下１桁.5数字の偏り6.スコア]
    var selectionNumber: Array<Int> = Array<Int>(repeating: 0,count:7)
    var rejectedNumber: Array<Int> = Array<Int>(repeating: 0,count:7)
    var lastWinNumber: Array<Int> = Array<Int>(repeating: 0,count:7)
    var judgmentResult:Array<Int> = Array<Int>(repeating: 0,count:6)
    var group = [[Int]](repeating: [Int](repeating: 0, count: 5),count: 3)//[category][マークの◯番目以降に、🔺数字が▲個存在する]
    var color:  Array<Int> = Array<Int>(repeating: 0,count:3)
    var hitRezult: Array<Int> = Array<Int>(repeating: 0,count:6)
    var mark = [[Int]](repeating: [Int](repeating: 0, count: 7),count: 5)   //[A〜E][mark]
    var occurrences:Array<Int> = Array<Int>(repeating: 0,count:43)
    var quickPick: Array<Int> = Array<Int>(repeating: 0,count:5)
    var backPosition: Int = 0
    var overalls: Array<Int> = Array<Int>(repeating: 0,count:3)
    var recently: Array<Int> = Array<Int>(repeating: 0,count:3)
    var score: Array<Int> = Array<Int>(repeating: 0,count:3)
    var graphdraw: Int = 0
    var rakutenData = [[Int]]()
    var graphCategory: Int = 0
    var sizeOfloto:Int = 0  //  43
    var markOfloto:Int = 0   //  6
    var slider:Int = 0
    var page: Int = 0

    init(category:Int,kaigo:Int,drivingMode:Int,keyboardMode:Int,myNumber:[[[Int]]],popUpButton:Int,counter:Int,cpuTimeInterval:Double,keyboard:[Int],layer:[[Int]],tab:Int,distribution:[[Int]],conditionsSet:[[Int]],selectionNumber:[Int],rejectedNumber:[Int],lastWinNumber:[Int],judgmentResult:[Int],group:[[Int]],color:[Int],hitRezult:[Int],mark:[[Int]],occurrences:[Int],quickPick:[Int],backPosition:Int,overalls:[Int],recently:[Int],score:[Int],rakutenData:[[Int]],graphdraw:Int,graphCategory:Int,sizeOfloto:Int,markOfloto:Int,slider:Int,page:Int) {
        self.category = category
        self.kaigo = kaigo
        self.drivingMode = drivingMode
        self.keyboardMode = keyboardMode
        self.layer = layer
        self.tab = tab
        self.myNumber = myNumber
        self.popUpButton = popUpButton
        self.counter = counter
        self.cpuTimeInterval = cpuTimeInterval
        self.keyboard = keyboard
        self.distribution = distribution
        self.conditionsSet = conditionsSet
        self.selectionNumber = selectionNumber
        self.rejectedNumber = rejectedNumber
        self.lastWinNumber = lastWinNumber
        self.judgmentResult = judgmentResult
        self.group = group
        self.color = color
        self.hitRezult = hitRezult
        self.mark = mark
        self.occurrences = occurrences
        self.quickPick = quickPick
        self.backPosition = backPosition
        self.overalls = overalls
        self.recently = recently
        self.score = score
        self.rakutenData = rakutenData
        self.graphdraw = graphdraw
        self.graphCategory = graphCategory
        self.sizeOfloto = sizeOfloto
        self.markOfloto = markOfloto
        self.slider = slider
        self.page = page
    }
    
    mutating func initializeKeyboard() {
        for i in 0...42 {
            self.keyboard[i]  = i + 1
        }
    }
    
    mutating func frequentlyKeyboard() {
        self.distribution.sort { $0[2] > $1[2] }
        for i in 0...42{
            self.keyboard[i] = self.distribution[i][0] + 1
        }
    }
    
}

let off = 0
let on = 1
let markOfMini = 5
let sizeOfMini = 31
let markOfLoto6 = 6
let sizeOfLoto6 = 43
let markOfLoto7 = 7
let sizeOfLoto7 = 37

enum lm:Int {
    case miniloto = 0
    case loto6 = 1
    case loto7 = 2
}

enum km:Int {
    case idling = 0
    case drive = 1
}

enum dm:Int {
    case normal = 0
    case frequentNumbers = 1
}
enum ly:Int {
    case redCircle = 0
    case redBollot = 1
}
enum cb:Int {
    case frequentNumbers = 0
    case reject = 1
    case continuousNumber = 2
    case offsetNunber = 3
    case score = 4
}

enum gc:Int {    
    case barChart = 0
    case dotChart = 1  
}
var lotoManage = Manager(category: 1,kaigo: 0,drivingMode: 0, keyboardMode:0,myNumber: [[[Int]]](repeating: [[Int]](repeating: [Int](repeating: 0, count: 7),count: 4),count:3),popUpButton:0,counter:0,cpuTimeInterval:3.0,keyboard: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43],layer: [[Int]](repeating: [Int](repeating: 0, count: 43),count: 2),tab:0,distribution: [[Int]](repeating: [Int](repeating: 0, count: 3),count: 43),conditionsSet: [[Int]](repeating: [Int](repeating: 0, count: 6),count: 3),selectionNumber: Array<Int>(repeating: 0,count:7), rejectedNumber: Array<Int>(repeating: 0,count:7), lastWinNumber: Array<Int>(repeating: 0,count:7),judgmentResult: Array<Int>(repeating: 1,count:6),group: [[Int]](repeating: [Int](repeating: 0, count: 5),count: 3),color: Array<Int>(repeating: 0,count:3),hitRezult:Array<Int>(repeating: 0,count:6),mark: [[Int]](repeating: [Int](repeating: 0, count: 7),count: 5),occurrences: Array<Int>(repeating: 0,count:43),quickPick: Array<Int>(repeating: 0,count:5),backPosition:0,overalls:Array<Int>(repeating: 0,count:3),recently:Array<Int>(repeating: 0,count:3),score:Array<Int>(repeating: 0,count:3),rakutenData:[[]],graphdraw: 0,graphCategory:0,sizeOfloto:43,markOfloto:6,slider: 0,page: 0)

// MARK: transfromFromZeroToKome
func transfromFromZeroToKome(inDt:Int)->String {
    if inDt == 0{
        return "※"
    }
    return String(inDt)
}

struct ShuffledIterator<T>: IteratorProtocol {
    
    typealias Element = T
    
    private var elements: [T]
    
    init(elements: [T]) {
        self.elements = elements
    }
    
    mutating func next() -> T? {
        guard elements.count > 0 else { return nil }
        let index = arc4random_uniform(UInt32(elements.count))
        return elements.remove(at: Int(index))
    }
}

struct LazyShuffledSequence<T>: LazySequenceProtocol {
    
    func makeIterator() -> ShuffledIterator<T> {
        return ShuffledIterator(elements: _elements)
    }
    
    private let _elements: [T]
    
    init(elements: [T]) {
        self._elements = elements
    }
    
}

func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
//    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
//    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
//    print("Time elapsed for \(title): \(timeElapsed) s")
}
// シャッフル
extension Array {
    
    mutating func shuffle() {
        for i in 0..<self.count {
            let j = Int(arc4random_uniform(UInt32(self.indices.last!)))
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
    
    var shuffled: Array {
        var copied = Array<Element>(self)
        copied.shuffle()
        return copied
    }
}
