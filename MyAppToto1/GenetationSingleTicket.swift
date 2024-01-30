//
//  Single.swift
//  totoVer1.0.1
//
//  Created by 岩田嘉吉 on 2017/05/19.
//  Copyright © 2017年 岩田嘉吉. All rights reserved
//

import Foundation

struct GeneratefirstOrdeTicketControl {
    var mark: Array<Int> = Array<Int>(repeating: 0,count:13)
    var target: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 4),count: 13)
    var numberofProcesses: Array<Int> = Array<Int>(repeating:0,count:13)
    var judgmentOnOff: Int
    
    init(mark:Array<Int>,target: [[Int]],numberofProcesses: Array<Int>,judgmentOnOff:Int) {
        self.mark = mark
        self.target = target
        self.numberofProcesses = numberofProcesses
        self.judgmentOnOff = judgmentOnOff
    }
}
struct cg {
    static let on = 0
    static let off = 1
}
var generatefirstOrder = GeneratefirstOrdeTicketControl(mark: Array<Int>(repeating: 0,count:13), target: [[Int]](repeating: [Int](repeating: 0, count: 4),count: 13),numberofProcesses: Array<Int>(repeating:0,count:13),judgmentOnOff:0)

func generatefirstOrderTicket() {
    //  MARK:シングルチケット生成
    if managment.judge[cm.prize][cm.high] == 0{
       managment.judge[cm.prize][cm.high] = 999_999_999_999
    }
    for i in 1...5 {
        if managment.judge[i][cm.high] == 0{
             managment.judge[i][cm.high] = 13
        }
    }
    multSCreen.minimumPrize = 999_999_999_999
    multSCreen.maximumPrize = 0
    for i in 0...managment.judge.count - 1{
        managment.judge[i][cm.count] = 0
    }
    multSCreen.mark[ms.afterCompression] = 0
    multSCreen.aggregate = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
    generatefirstOrder.target = [[Int]](repeating: [Int](repeating: 0, count: 4),count: 13)
    generatefirstOrder.numberofProcesses = Array<Int>(repeating: 0,count:13)
    
    //  シングルマークの例、＿　＿　○　numberofProcesses[1],target[0,3,0,0] 1 origin左詰め、
    //  ダブルマークの例、　＿　○　○　numberofProcesses[2],target[0,2,3,0] 1 origin左詰め、
    //  トリプルマークの例、○　○　○　numberofProcesses[3],target[0,1,2,3] 1 origin左詰め、
    //  引分け0がデータありの0かデータなしの0なのか紛らわしいため、1,0,2と記録すべきところを1,2,3と仮置きした。
    for match in 0...managment.match.count - 1 {
        for mark in 0...2 {
            if managment.bed[match][mark] > 0{
                generatefirstOrder.numberofProcesses[match] += 1
                generatefirstOrder.target[match][generatefirstOrder.numberofProcesses[match]] = mark + 1
            }
        }
    }
    
    multiView.sample1.removeAll()
    multiView.sample2.removeAll()
    var fillIn = 0
    var serialNumber = 0
    
    for match in 0...managment.match.count - 1 {
        if generatefirstOrder.numberofProcesses[match] > 0{
            fillIn += 1
        }
    }
    
    if fillIn == managment.match.count {
        firstOrderTickets.removeAll()
        
        for i0 in 0...generatefirstOrder.numberofProcesses[0] - 1 {
            generatefirstOrder.mark[0] = generatefirstOrder.target[0][i0 + 1]
            for i1 in 0...generatefirstOrder.numberofProcesses[1] - 1 {
                generatefirstOrder.mark[1] = generatefirstOrder.target[1][i1 + 1]
                for i2 in 0...generatefirstOrder.numberofProcesses[2] - 1 {
                    generatefirstOrder.mark[2] = generatefirstOrder.target[2][i2 + 1]
                    for i3 in 0...generatefirstOrder.numberofProcesses[3] - 1 {
                        generatefirstOrder.mark[3] = generatefirstOrder.target[3][i3 + 1]
                        for i4 in 0...generatefirstOrder.numberofProcesses[4] - 1 {
                            generatefirstOrder.mark[4] = generatefirstOrder.target[4][i4 + 1]
                            for i5 in 0...generatefirstOrder.numberofProcesses[5] - 1 {
                                generatefirstOrder.mark[5] = generatefirstOrder.target[5][i5 + 1]
                                for i6 in 0...generatefirstOrder.numberofProcesses[6] - 1 {
                                    generatefirstOrder.mark[6] = generatefirstOrder.target[6][i6 + 1]
                                    for i7 in 0...generatefirstOrder.numberofProcesses[7] - 1 {
                                        generatefirstOrder.mark[7] = generatefirstOrder.target[7][i7 + 1]
                                        for i8 in 0...generatefirstOrder.numberofProcesses[8] - 1 {
                                            generatefirstOrder.mark[8] = generatefirstOrder.target[8][i8 + 1]
                                            for i9 in 0...generatefirstOrder.numberofProcesses[9] - 1 {
                                                generatefirstOrder.mark[9] = generatefirstOrder.target[9][i9 + 1]
                                                for i10 in 0...generatefirstOrder.numberofProcesses[10] - 1 {
                                                    generatefirstOrder.mark[10] = generatefirstOrder.target[10][i10 + 1]
                                                    for i11 in 0...generatefirstOrder.numberofProcesses[11] - 1 {
                                                        generatefirstOrder.mark[11] = generatefirstOrder.target[11][i11 + 1]
                                                        for i12 in 0...generatefirstOrder.numberofProcesses[12] - 1{
                                                            generatefirstOrder.mark[12] = generatefirstOrder.target[12][i12 + 1]

                                                            let x = editFirstOrderProcessing()
                                                            let (judge,prize,judgmentResult) = judgeFirstOrderProcessing(probability: x)
                                                            if judgmentResult == true {
                                                                serialNumber += 1
                                                                firstOrderTicket.firstOrder = serialNumber
                                                                firstOrderTickets.append(firstOrderTicket)
                                                                multSCreen.mark[ms.afterCompression] += 1
                                                            }
                                                            managment.judge[cm.prize][cm.count] += judge[cm.prize] as! Int
                                                            managment.judge[cm.majorWin][cm.count] += judge[cm.majorWin] as! Int
                                                            managment.judge[cm.minorWin][cm.count] += judge[cm.minorWin] as! Int
                                                            managment.judge[cm.drawMatch][cm.count] += judge[cm.drawMatch] as! Int
                                                            managment.judge[cm.homeWin][cm.count] += judge[cm.homeWin] as! Int
                                                            managment.judge[cm.awayWin][cm.count] += judge[cm.awayWin] as! Int
                                                            managment.judge[cm.under25][cm.count] += judge[cm.under25] as! Int
                                                            managment.judge[cm.under15][cm.count] += judge[cm.under15] as! Int
                                                            
                                                            
                                                            if  multSCreen.minimumPrize >  prize {
                                                                multSCreen.minimumPrize =  prize
                                                            }
                                                            if  multSCreen.maximumPrize <  prize {
                                                                multSCreen.maximumPrize =  prize
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }else{
        // print("Kinyumore!")
    }
    
    let totoOfficialSiteBuyLimit: UInt32 = 486
    if firstOrderTickets.count <= totoOfficialSiteBuyLimit{
        temporaryTickets.removeAll()
        for ticket in firstOrderTickets {
            temporaryTicket = ticket
            temporaryTicket.buyer = String(arc4random_uniform(totoOfficialSiteBuyLimit - 1))
            temporaryTickets.append(temporaryTicket)
        }
        temporaryTickets.sort(by: {$0.buyer < $1.buyer})
        firstOrderTickets = temporaryTickets
        temporaryTickets.removeAll()
    }
    
    for ticket in firstOrderTickets {
        for match in 0...managment.match.count - 1 {
            if ticket.mark[match] == 1 {
                multSCreen.aggregate[match][cm.home] += 1
            }else if ticket.mark[match] == 0{
                multSCreen.aggregate[match][cm.draw] += 1
            }else if ticket.mark[match] == 2{
                multSCreen.aggregate[match][cm.away] += 1
            }
        }
    }

}

 func editFirstOrderProcessing() -> Double{
    //  MARK:シングルチケッットの内容編集
    for match in 0...managment.match.count - 1 {   //  仮置き 1,2,3 をマーク1,0,2に置き換え
        firstOrderTicket.mark[match] = generatefirstOrder.mark[match]
        firstOrderTicket.mark[match] = Int(String(firstOrderTicket.mark[match]).replacingOccurrences(of: "2", with: "0"))!
        firstOrderTicket.mark[match] = Int(String(firstOrderTicket.mark[match]).replacingOccurrences(of: "3", with: "2"))!
    }
    for i in 0...firstOrderTicket.rank.count - 1 {
        firstOrderTicket.rank[i] = 0
    }
    var Parsent:Double = 0
    var probability:Double = 1.0

    for match in 0...managment.match.count - 1 {
        if firstOrderTicket.mark[match] == 1{
            Parsent = Double(managment.rate[match][cm.home])
        }else if firstOrderTicket.mark[match] == 0{
            Parsent = Double(managment.rate[match][cm.draw])
        }else if firstOrderTicket.mark[match] == 2{
            Parsent = Double(managment.rate[match][cm.away])
        }
        probability = probability * Parsent
        var positionToPlace = 0
        if Parsent <= 0.15{
            positionToPlace = 8
        }else if Parsent <= 0.25{
            positionToPlace = 7
        }else if Parsent <= 0.35{
            positionToPlace = 6
        }else if Parsent <= 0.45{
            positionToPlace = 5
        }else if Parsent <= 0.55{
            positionToPlace = 4
        }else if Parsent <= 0.65{
            positionToPlace = 3
        }else if Parsent <= 0.75{
            positionToPlace = 2
        }else if Parsent <= 0.85{
            positionToPlace = 1
        }else if Parsent <= 1.00{
            positionToPlace = 0
        }
        firstOrderTicket.rank[positionToPlace] = firstOrderTicket.rank[positionToPlace] + 1
    }
 
    let haitouGensi:Int = Int(Double(homeScreen.user[ch.prospectsSales]) * 0.5 * 0.7)
    firstOrderTicket.winner = Int(Double(homeScreen.user[ch.prospectsSales]) / 100 * probability)
    if firstOrderTicket.winner == 0{
        firstOrderTicket.winner = 1
    }
    firstOrderTicket.prize =  Int((Double(haitouGensi) + Double(homeScreen.user[ch.carryOver])) / Double(firstOrderTicket.winner) / Double(10_000))
    firstOrderTicket.difficulty = Int(1 / probability)
    var max:Float = 0
    firstOrderTicket.draw = 0
    firstOrderTicket.major = 0
    
    for match in 0...managment.match.count - 1 {
        if managment.rate[match][cm.home] > managment.rate[match][cm.away]{
            max = managment.rate[match][cm.home]}
        else{
            max = managment.rate[match][cm.away]
        }
 
        if firstOrderTicket.mark[match] == 0 {
            firstOrderTicket.draw += 1
        }
        if firstOrderTicket.mark[match] == 1{
            if managment.rate[match][cm.home] == max{
                firstOrderTicket.major += 1
            }
        }
        if firstOrderTicket.mark[match] == 2{
            if managment.rate[match][cm.away] == max{
                firstOrderTicket.major += 1
            }
        }
    }
    firstOrderTicket.minor = 13 - firstOrderTicket.major - firstOrderTicket.draw
    var mainstream = 0
    var j = 0
    for match in 0...managment.match.count - 1 {
        if firstOrderTicket.mark[match] == 1{
            j = 0
        }else if firstOrderTicket.mark[match] == 0{
            j = 1
        }else if firstOrderTicket.mark[match] == 2{
            j = 2
        }
        if managment.bed[match][j]  == 2{
            mainstream += 1
        }
    }
    firstOrderTicket.mainstream = mainstream
    firstOrderTicket.hit = 0
    firstOrderTicket.firstOrder = 0
    firstOrderTicket.lastOrder = 0
    firstOrderTicket.buyer = ""
    return probability
}

func judgeFirstOrderProcessing(probability: Double) -> (judge:Array<Any>,prize:Int,judgmentResult:Bool) {
    // MARK:シングルチケッットの抽出条件を判定
    var judge:Array<Int> = Array<Int>(repeating:0,count:8)
    var judgmentResult = false
    let carryOver = Int(homeScreen.user[ch.carryOver] / 10_000)
    let prospectsSales = Int(Double(managment.judge[cm.prize][cm.high] - carryOver) * 10_000 / 0.5 / 0.7)
    let winner: Double = Double(prospectsSales / 100) * probability

    if managment.judge[cm.prize][cm.judge] == off{
        judge[cm.prize] = on
    }else if  (managment.judge[cm.prize][cm.low] + managment.judge[cm.prize][cm.high]) == 0{
        judge[cm.prize] = on
    }else if firstOrderTicket.prize >= managment.judge[cm.prize][cm.low] && firstOrderTicket.prize <= managment.judge[cm.prize][cm.high] && winner >= 1{
        judge[cm.prize] = on
    }
    
    if managment.judge[cm.majorWin][cm.judge] == off{
        judge[cm.majorWin] = on
    }else if (managment.judge[cm.majorWin][cm.low] + managment.judge[cm.majorWin][cm.high]) == 0 {
        judge[cm.majorWin] = on
    }else if firstOrderTicket.major >= managment.judge[cm.majorWin][cm.low] && firstOrderTicket.major <= managment.judge[cm.majorWin][cm.high] {
        judge[cm.majorWin] = on
    }
    
    if managment.judge[cm.minorWin][cm.judge] == off{
        judge[cm.minorWin] = on
    }else if (managment.judge[cm.minorWin][cm.low] + managment.judge[cm.minorWin][cm.high]) == 0 {
        judge[cm.minorWin] = on
    }else if firstOrderTicket.minor >= managment.judge[cm.minorWin][cm.low] && firstOrderTicket.minor <= managment.judge[cm.minorWin][cm.high] {
        judge[cm.minorWin] = on
    }
    
    if managment.judge[cm.drawMatch][cm.judge] == off{
        judge[cm.drawMatch] = on
    }else if (managment.judge[cm.drawMatch][cm.low] + managment.judge[cm.drawMatch][cm.high] == 0) {
        judge[cm.drawMatch] = on
    }else if firstOrderTicket.draw >= managment.judge[cm.drawMatch][cm.low] && firstOrderTicket.draw <= managment.judge[cm.drawMatch][cm.high] {
        judge[cm.drawMatch] = on
    }
    
    var sumHome = 0
    var sumAwe = 0
 
    for i in 0...managment.match.count - 1{
        if firstOrderTicket.mark[i] == 1{
            sumHome += 1
        }else if firstOrderTicket.mark[i] == 2{
            sumAwe += 1
        }
    }
    
    if managment.judge[cm.homeWin][cm.judge] == off{
        judge[cm.homeWin] = on
    }else if (managment.judge[cm.homeWin][cm.low] + managment.judge[cm.homeWin][cm.high]) == 0  {
        judge[cm.homeWin] = on
    }else if sumHome >= managment.judge[cm.homeWin][cm.low] && sumHome <= managment.judge[cm.homeWin][cm.high]  {
        judge[cm.homeWin] = on
    }
    
    if managment.judge[cm.awayWin][cm.judge] == off{
        judge[cm.awayWin] = on
    }else if (managment.judge[cm.awayWin][cm.low] + managment.judge[cm.awayWin][cm.high]) == 0{
        judge[cm.awayWin] = on
    }else if sumAwe >= managment.judge[cm.awayWin][cm.low] && sumAwe <= managment.judge[cm.awayWin][cm.high] {
        judge[cm.awayWin] = on
    }
    
    if managment.judge[cm.under25][cm.judge] == off{
        judge[cm.under25] = on
    }else if (managment.judge[cm.under25][cm.low] + managment.judge[cm.under25][cm.high]) == 0 {
        judge[cm.under25] = on
    }else if firstOrderTicket.rank[7] >= managment.judge[cm.under25][cm.low] && firstOrderTicket.rank[7] <= managment.judge[cm.under25][cm.high] {
        judge[cm.under25] = on
    }
    
    if managment.judge[cm.under15][cm.judge] == off{
        judge[cm.under15] = on
    }else if (managment.judge[cm.under15][cm.low] + managment.judge[cm.under15][cm.high]) == 0 {
        judge[cm.under15] = on
    }else if firstOrderTicket.rank[8] >= managment.judge[cm.under15][cm.low] && firstOrderTicket.rank[8] <= managment.judge[cm.under15][cm.high] {
        judge[cm.under15] = on
    }
    
    
    multiView.sample1.append(firstOrderTicket.prize)
    
    if generatefirstOrder.judgmentOnOff == cg.off{
       judgmentResult = true
    }else if judge == Array<Int>(repeating:on,count:8){
        judgmentResult = true
    }
    if judgmentResult == true{
        multiView.sample2.append(firstOrderTicket.prize)
    }
 
    return (judge,firstOrderTicket.prize,judgmentResult)
    
}
