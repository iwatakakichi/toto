//
//  ViewControllerTotoOne.swift
//  MyAppToto1
//
//  Created by 岩田嘉吉 on 2017/07/01.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//

import Cocoa

class ViewControllerTotoOne: NSViewController, NSTableViewDataSource {
    
    @IBOutlet weak var appendedView: NSTableView!
    @IBOutlet weak var guidance1Label: NSTextField!
    @IBOutlet weak var stampLabel: NSTextField!
    @IBOutlet weak var saleLabel: NSTextField!
    @IBOutlet weak var selection0: NSButton!
    @IBOutlet weak var selection1: NSButton!
    @IBOutlet weak var selection2: NSButton!
    @IBOutlet weak var selection3: NSButton!
    @IBOutlet weak var selection4: NSButton!
    @IBOutlet weak var selection5: NSButton!
    @IBOutlet weak var selection6: NSButton!
    @IBOutlet weak var selection7: NSButton!
    @IBOutlet weak var selection8: NSButton!
    @IBOutlet weak var selection9: NSButton!
    @IBOutlet weak var remarksButton: NSButton!
    @IBOutlet weak var accountingRules: NSButton!
    
    let checkPoint:Int = 10500 //５％以上を抽出
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        saleLabel.stringValue = "第" + String(homeScreen.user[ch.sale]) + "回"
        guidance1Label.stringValue = ""
        if totoOneVoteRead() == false{
            let textFileName = "totoOne.html"
            let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            let targetTextFilePath = documentDirectoryFileURL?.appendingPathComponent(textFileName)
            guidance1Label.stringValue = totoOneScreenGuidance + String(describing: targetTextFilePath) + "です。"
        }
        
        for master in 0...ct.master - 1{
            if totoOne.mark[13][master] == ""{
                totoOneScreen.selection[master] = off
            }
        }
        //  under25
        for master in 0...ct.master - 1{
            var display = Array<String>(repeating: "",count:13)
            for match in 0...managment.match.count - 1 {
                
                if totoOne.mark[match][master].contains("[1][▒][▒]") || totoOne.mark[match][master].contains("[1][0][▒]") || totoOne.mark[match][master].contains("[1][▒][2]") || totoOne.mark[match][master].contains("[1][0][2]") {
                    if managment.rate[match][0] < 0.15{
                        display[match] = "*"
                    } else if managment.rate[match][0] < 0.25 {
                        display[match] = "-"
                    }
                }
                
                if totoOne.mark[match][master].contains("[▒][0][▒]") || totoOne.mark[match][master].contains("[1][0][▒]") || totoOne.mark[match][master].contains("[▒][0][2]") || totoOne.mark[match][master].contains("[1][0][2]") {
                    if managment.rate[match][1] < 0.15{
                        display[match] = "*"
                    } else if managment.rate[match][1] < 0.25 {
                        display[match] = "-"
                    }
                }
                
                if totoOne.mark[match][master].contains("[▒][▒][2]") || totoOne.mark[match][master].contains("[1][▒][2]") || totoOne.mark[match][master].contains("[▒][0][2]") || totoOne.mark[match][master].contains("[1][0][2]") {
                    if managment.rate[match][2] < 0.15{
                        display[match] = "*"
                    } else if managment.rate[match][2] < 0.25 {
                        display[match] = "-"
                    }
                }
            }
            
            display = display.sorted()
            for i in 0...managment.match.count - 1{
                totoOne.mark[14][master] = totoOne.mark[14][master] + display[i]
            }
        }
        
        var _ = selectionSub()
        
        switch totoOneScreen.difference {
        case 0:
            totoOneScreen.popularityBed = managment.bed
            accountingRules.title = String(totoOneScreen.accountingRules) + "％ルール適用"
        case 1:
            totoOneScreen.differenceBed = managment.bed
            accountingRules.title = "元に戻す"
        default: print("default")
        }
        
        totoOneScreen.uppersideTable = totoOne.mark
        totoOneScreen.lowerLeftSideTabel = totoOneScreen.appendedTable
        totoOneScreen.stamp += 1
        stampLabel.intValue = Int32(totoOneScreen.stamp)
        
        if totoOneScreen.selection[0] == off{
            selection0.doubleValue = 0.0
        }
        if totoOneScreen.selection[1] == off{
            selection1.doubleValue = 0.0
        }
        if totoOneScreen.selection[2] == off{
            selection2.doubleValue = 0.0
        }
        if totoOneScreen.selection[3] == off{
            selection3.doubleValue = 0.0
        }
        if totoOneScreen.selection[4] == off{
            selection4.doubleValue = 0.0
        }
        if totoOneScreen.selection[5] == off{
            selection5.doubleValue = 0.0
        }
        if totoOneScreen.selection[6] == off{
            selection6.doubleValue = 0.0
        }
        if totoOneScreen.selection[7] == off{
            selection7.doubleValue = 0.0
        }
        if totoOneScreen.selection[8] == off{
            selection8.doubleValue = 0.0
        }
        if totoOneScreen.selection[9] == off{
            selection9.doubleValue = 0.0
        }
        if totoOneScreen.remarks == off{
            remarksButton.doubleValue = 0.0
        } else {
            remarksButton.doubleValue = 1.0
        }
        
        //  MARK:試合結果が出ていれば、あたりハズレを表示
        if homeScreen.matchResult != Array<Int>(repeating: 0,count:13) {
            totoOneScreen.hitCount = Array<Int>(repeating: 0,count:10)
            for match in 0...managment.match.count - 1 {
                for master in 0...co.displayColumnSize - 1 {
                    totoOneScreen.uppersideTable[match][master] = reverseMark(mark: totoOneScreen.uppersideTable[match][master])
                    if homeScreen.matchResult[match] == 1{
                        if totoOneScreen.uppersideTable[match][master].range(of: "a") != nil{
                            totoOneScreen.undersideTable[match][master] = "○"
                            totoOneScreen.hitCount[master] += 1}
                        else{
                            totoOneScreen.undersideTable[match][master] = "×"
                        }
                    }
                    if homeScreen.matchResult[match] == 0{
                        if totoOneScreen.uppersideTable[match][master].range(of: "b") != nil{
                            totoOneScreen.undersideTable[match][master] = "○"
                            totoOneScreen.hitCount[master] += 1}
                        else{
                            totoOneScreen.undersideTable[match][master] = "×"
                        }
                    }
                    if homeScreen.matchResult[match] == 2{
                        if totoOneScreen.uppersideTable[match][master].range(of: "c") != nil{
                            totoOneScreen.undersideTable[match][master] = "○"
                            totoOneScreen.hitCount[master] += 1}
                        else{
                            totoOneScreen.undersideTable[match][master] = "×"
                        }
                    }
                    totoOneScreen.uppersideTable[match][master] = replaceMark(mark: totoOneScreen.uppersideTable[match][master])
                }
            }
            for master in 0...co.displayColumnSize - 1 {
                totoOneScreen.undersideTable[13][master] = String(totoOneScreen.hitCount[master])
            }
        }
  
        var _  = multScreenMark()

    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView.tag == 0 {
            return managment.match.count
        }
        if tableView.tag == 1 {
            return managment.rateDisp.count
        }
        if tableView.tag == 2 {
            return totoOneScreen.uppersideTable.count
        }
        if tableView.tag == 3 {
            return totoOneScreen.undersideTable.count
        }
        if tableView.tag == 4 {
            return totoOneScreen.lowerLeftSideTabel.count
        }
        if tableView.tag == 5 {
            return homeScreen.matchResult.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        if tableView.tag == 0{
            if let tcol = tableColumn {
                if(tcol.identifier.rawValue == "NO") {
                    return managment.match[row][0]
                }else if(tcol.identifier.rawValue == "HOME") {
                    return managment.match[row][1]
                }else if(tcol.identifier.rawValue == "AWE") {
                    return managment.match[row][2]
                }
            }
        }
        
        if tableView.tag == 1{
            if let tcol = tableColumn {
                if(tcol.identifier.rawValue == "HOME") {
                    return managment.rateDisp[row][0]
                } else if(tcol.identifier.rawValue == "DRAW") {
                    return managment.rateDisp[row][1]
                }else if(tcol.identifier.rawValue == "AWE") {
                    return managment.rateDisp[row][2]
                }
            }
        }

        if tableView.tag == 2{
            if let tcol = tableColumn {
                if(tcol.identifier.rawValue == "master0") {
                    return totoOneScreen.uppersideTable[row][0]
                }else if(tcol.identifier.rawValue == "master1") {
                    return totoOneScreen.uppersideTable[row][1]
                }else if(tcol.identifier.rawValue == "master2") {
                    return totoOneScreen.uppersideTable[row][2]
                }else if(tcol.identifier.rawValue == "master3") {
                    return totoOneScreen.uppersideTable[row][3]
                }else if(tcol.identifier.rawValue == "master4") {
                    return totoOneScreen.uppersideTable[row][4]
                }else if(tcol.identifier.rawValue == "master5") {
                    return totoOneScreen.uppersideTable[row][5]
                }else if(tcol.identifier.rawValue == "master6") {
                    return totoOneScreen.uppersideTable[row][6]
                }else if(tcol.identifier.rawValue == "master7") {
                    return totoOneScreen.uppersideTable[row][7]
                }else if(tcol.identifier.rawValue == "master8") {
                    return totoOneScreen.uppersideTable[row][8]
                }else if(tcol.identifier.rawValue == "master9") {
                    return totoOneScreen.uppersideTable[row][9]
                }
            }
        }
 
        if tableView.tag == 3{
            if let tcol = tableColumn {
                if(tcol.identifier.rawValue == "master0") {
                    return totoOneScreen.undersideTable[row][0]
                }else if(tcol.identifier.rawValue == "master1") {
                    return totoOneScreen.undersideTable[row][1]
                }else if(tcol.identifier.rawValue == "master2") {
                    return totoOneScreen.undersideTable[row][2]
                }else if(tcol.identifier.rawValue == "master3") {
                    return totoOneScreen.undersideTable[row][3]
                }else if(tcol.identifier.rawValue == "master4") {
                    return totoOneScreen.undersideTable[row][4]
                }else if(tcol.identifier.rawValue == "master5") {
                    return totoOneScreen.undersideTable[row][5]
                }else if(tcol.identifier.rawValue == "master6") {
                    return totoOneScreen.undersideTable[row][6]
                }else if(tcol.identifier.rawValue == "master7") {
                    return totoOneScreen.undersideTable[row][7]
                }else if(tcol.identifier.rawValue == "master8") {
                    return totoOneScreen.undersideTable[row][8]
                }else if(tcol.identifier.rawValue == "master9") {
                    return totoOneScreen.undersideTable[row][9]
                }
            }
        }

        if tableView.tag == 4{
            if let tcol = tableColumn {
                if(tcol.identifier.rawValue == "totalization0") {
                    return row + 1
                }else if(tcol.identifier.rawValue == "totalization1") {
                    return totoOneScreen.lowerLeftSideTabel[row][0]
                }else if(tcol.identifier.rawValue == "totalization2") {
                    return totoOneScreen.lowerLeftSideTabel[row][1]
                }else if(tcol.identifier.rawValue == "totalization3") {
                    return totoOneScreen.lowerLeftSideTabel[row][2]
                }else if(tcol.identifier.rawValue == "totalization4") {
                    return totoOneScreen.lowerLeftSideTabel[row][3]
                }else if(tcol.identifier.rawValue == "totalization5") {
                    return totoOneScreen.lowerLeftSideTabel[row][4]
                }
            }
        }
        
        if tableView.tag == 5{
            if let tcol = tableColumn {
                if(tcol.identifier.rawValue == "rezultNo") {
                    return row + 1
                }else if(tcol.identifier.rawValue == "rezult") {
                    if homeScreen.matchResult == Array<Int>(repeating: 0,count:13){
                        return ""
                    }else{
                        return homeScreen.matchResult[row]
                    }
                }
            }
        }
       
        return 0
    }

    @IBAction func selection(_ sender: Any) {
        totoOneScreen.selection[Int((sender as AnyObject).tag)] += 1
        totoOneScreen.selection[Int((sender as AnyObject).tag)] = totoOneScreen.selection[Int((sender as AnyObject).tag)] % 2
      
        loadView()
    }
    
    @IBAction func remarks(_ sender: Any) {
        totoOneScreen.remarks = Int(remarksButton.doubleValue)
    }
  
    @IBAction func accountingRules(_ sender: Any) {
        managment.bed = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
        totoOneScreen.difference += 1
        totoOneScreen.difference = totoOneScreen.difference % 2
        
        loadView()
    }
    
    func selectionSub(){
        totoOneScreen.appendedTable = [[Int]](repeating: [Int](repeating: 0, count: 5),count: 13)
        totoOne.push = [[[Int]]](repeating:[[Int]](repeating: [Int](repeating: 0, count: 3),count: 13),count: 10)
        managment.bed = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
        
        
        for match in 0...managment.match.count - 1{
            for master in 0...ct.master - 1{
                totoOne.mark[match][master] = reverseMark(mark: totoOne.mark[match][master])
            }
        }

        var selection = 0
        for i in 0...9{
            if totoOneScreen.selection[i] == 1{
                selection += 1
            }
        }
        
        for master in 0...ct.master - 1 {
            if totoOneScreen.selection[master] == 1{
                for match in 0...managment.match.count - 1 {
                    if  totoOne.mark[match][master] == "a" || totoOne.mark[match][master] == "ab" || totoOne.mark[match][master] == "ac" || totoOne.mark[match][master] == "abc"{
                        totoOne.push[master][match][ct.home] += 1  // add
                        if managment.rate[match][ct.home] > managment.rate[match][ct.away]{
                            totoOne.push[master][match][ct.home] += 1
                        }
                    }
                    if  totoOne.mark[match][master] == "b" || totoOne.mark[match][master] == "ab" || totoOne.mark[match][master] == "bc" || totoOne.mark[match][master] == "abc"{
                        totoOne.push[master][match][ct.draw] += 1  // add
                    }
                    if  totoOne.mark[match][master] == "c" || totoOne.mark[match][master] == "ac" || totoOne.mark[match][master] == "bc" || totoOne.mark[match][master] == "abc"{
                        totoOne.push[master][match][ct.away] += 1  // add
                        if managment.rate[match][ct.home] < managment.rate[match][ct.away]{
                            totoOne.push[master][match][ct.away] += 1
                        }
                    }
                }
            }
        }
        
     
        for match in 0...managment.match.count - 1 {    // ホーム、引き分け、アウエー、本命、対抗の別表を作表
            for master in 0...ct.master - 1{
                if totoOneScreen.selection[master] == 1{
             
                    let strCount = totoOne.mark[match][master].count
                    var votePoint:Int = 0
                    if strCount == 1{
                        votePoint = 1000
                    }else if strCount == 2{
                        votePoint = 500
                    }else if strCount == 3{
                        votePoint = 333
                    }
         
                    if totoOne.mark[match][master].range(of: "a") != nil {
                        totoOneScreen.appendedTable[match][ct.home] += votePoint
                    }
                    if totoOne.mark[match][master].range(of: "b") != nil {
                        totoOneScreen.appendedTable[match][ct.draw] += votePoint
                    }
                    if totoOne.mark[match][master].range(of: "c") != nil {
                        totoOneScreen.appendedTable[match][ct.away] += votePoint
                    }
                    
                    if totoOne.mark[match][master].range(of: "a") != nil {
                        if managment.rate[match][cm.home] > managment.rate[match][cm.away]{
                            totoOneScreen.appendedTable[match][ct.major] += votePoint
                        }
                    }
                    if totoOne.mark[match][master].range(of: "a") != nil {
                        if managment.rate[match][cm.home] < managment.rate[match][cm.away]{
                            totoOneScreen.appendedTable[match][ct.minor] += votePoint
                        }
                    }
                    if totoOne.mark[match][master].range(of: "c") != nil {
                        if managment.rate[match][cm.home] < managment.rate[match][cm.away]{
                            totoOneScreen.appendedTable[match][ct.major] += votePoint
                        }
                    }
                    if totoOne.mark[match][master].range(of: "c") != nil {
                        if managment.rate[match][cm.home] > managment.rate[match][cm.away]{
                            totoOneScreen.appendedTable[match][ct.minor] += votePoint
                        }
                    }
                }
            }
        }
        
        if selection > 0{
            for match in 0...managment.match.count - 1 {    // ホーム、引き分け、アウエー、本命、対抗の別表を作表
                for appendedTableColumn in 0...4{
                    totoOneScreen.appendedTable[match][appendedTableColumn] = Int((totoOneScreen.appendedTable[match][appendedTableColumn] + 5) / (selection * 10))
                }
                if totoOneScreen.appendedTable[match][1] > 0 {
                    totoOneScreen.appendedTable[match][1] = 100 - (totoOneScreen.appendedTable[match][0] + totoOneScreen.appendedTable[match][2])
                }
            }
        }
   
        if managment.judge[cm.majorWin][cm.high] > 0{
            // MARK:本命の試合をmultSCreenで指定した本命の上限数まで抽出
           
            for match in 0...managment.match.count - 1 {
                var difference:Int = 0
                var officalVote:String = ""
                let totoOneVote = String(format: "%03d",totoOneScreen.appendedTable[match][ct.major])
                let officalHome = Int(managment.rate[match][cm.home] * 10000)
                let officalAway = Int(managment.rate[match][cm.away] * 10000)
        
                if managment.rate[match][cm.home] > managment.rate[match][cm.away]{
                    difference = totoOneScreen.appendedTable[match][ct.major] * 100 - Int(managment.rate[match][cm.home] * 10000)
                    if difference < totoOneScreen.accountingRules * 100{
                        difference = 0
                    }
                    officalVote = String(format: "%05d",officalHome)
                }else{
                    difference = totoOneScreen.appendedTable[match][ct.major] * 100 - Int(managment.rate[match][cm.away] * 10000)
                    if difference < totoOneScreen.accountingRules * 100{
                        difference = 0
                    }
                    officalVote = String(format: "%05d",officalAway)
                }
                
                switch totoOneScreen.difference{
                    case 0:
                        totoOne.major[match] = totoOneVote + "/" + officalVote + "/"  + String(format: "%02d",match + 1)
                    case 1:
                        totoOne.major[match] = String(format: "%05d",difference) + "/" + totoOneVote + "/" + officalVote + "/"  + String(format: "%02d",match + 1)
                    default: print("default")
                 }
          
            }
            totoOne.major.sort{ $0 > $1 }
            //  print("totoOne.major 本命 \(managment.judge[cm.majorWin][cm.high])つまで\(totoOne.major)") // ロジックを忘れたらここに戻っておいで
            for i in 0...managment.judge[cm.majorWin][cm.high] - 1{ //  本命の試合をmultSCreenで指定した本命の上限数まで拾う
                for match in 0...managment.match.count - 1{
                    let str1 =  String(format: "%02d",match + 1)
                    let str2 = String(totoOne.major[i].suffix(2))
                    if str1 == str2{
                        if managment.rate[match][cm.home] > managment.rate[match][cm.away]{
                            managment.bed[match][cm.home] = 2
                        }else{
                            managment.bed[match][cm.away] = 2
                        }
                    }
                }
            }
        }
        
        if managment.judge[cm.minorWin][cm.high] > 0{
            // MARK:対抗の試合ををmultSCreenで指定した対抗の上限数まで抽出
                
            for match in 0...managment.match.count - 1 {
                var difference:Int = 0
                var officalVote:String = ""
                let totoOneVote = String(format: "%03d",totoOneScreen.appendedTable[match][ct.minor])
                let officalHome = Int(managment.rate[match][cm.home] * 10000)
                let officalAway = Int(managment.rate[match][cm.away] * 10000)
                    
                if managment.rate[match][cm.home] < managment.rate[match][cm.away]{
                    difference = totoOneScreen.appendedTable[match][ct.minor] * 100 - Int(managment.rate[match][cm.home] * 10000)
                    if difference < totoOneScreen.accountingRules * 100{
                        difference = 0
                    }
                        officalVote = String(format: "%05d",officalHome)
                }else{
                    difference = totoOneScreen.appendedTable[match][ct.minor] * 100 - Int(managment.rate[match][cm.away] * 10000)
                    if difference < totoOneScreen.accountingRules * 100{
                        difference = 0
                    }
                    officalVote = String(format: "%05d",officalAway)
                }
                    
                switch totoOneScreen.difference{
                case 0:
                    totoOne.major[match] = totoOneVote + "/" + officalVote + "/"  + String(format: "%02d",match + 1)
                case 1:
                    totoOne.major[match] = String(format: "%05d",difference) + "/" + totoOneVote + "/" + officalVote   + "/" + String(format: "%02d",match + 1)
                default: print("default")
                }
    
            }
            totoOne.major.sort{ $0 > $1 }
            //  print("totoOne.major 対抗 \(managment.judge[cm.minorWin][cm.high])つまで\(totoOne.major)")
            for i in 0...managment.judge[cm.minorWin][cm.high] - 1{
                for match in 0...managment.match.count - 1{
                    let str1 =  String(format: "%02d",match + 1)
                    let str2 = String(totoOne.major[i].suffix(2))
                    if str1 == str2{
                        if managment.rate[match][cm.home] < managment.rate[match][cm.away]{
                            managment.bed[match][cm.home] = 1
                            
                        }else{
                            managment.bed[match][cm.away] = 1
                        }
                    }
                }
            }
        }
        
        if managment.judge[cm.drawMatch][cm.high] > 0{
            // MARK:引き分けの試合ををmultSCreenで指定した引き分けの上限数まで抽出
            
            for match in 0...managment.match.count - 1 {
                var difference:Int = 0
                var officalVote:String = ""
                let totoOneVote = String(format: "%03d",totoOneScreen.appendedTable[match][ct.draw])
                let officalDraw = Int(managment.rate[match][cm.draw] * 10000)
                
                difference = totoOneScreen.appendedTable[match][ct.draw] * 100 - Int(managment.rate[match][cm.draw] * 10000)
                if difference < totoOneScreen.accountingRules * 100{
                    difference = 0
                }
                officalVote = String(format: "%05d",officalDraw)
             
                switch totoOneScreen.difference{
                case 0:
                    totoOne.major[match] = totoOneVote + "/" + officalVote + "/"  + String(format: "%02d",match + 1)
                case 1:
                    totoOne.major[match] = String(format: "%05d",difference) + "/" + totoOneVote + "/" + officalVote + "/"  + String(format: "%02d",match + 1)
                default: print("default")
                }
                
            }
            totoOne.major.sort{ $0 > $1 }
            //  print("totoOne.major 分け \(managment.judge[cm.drawMatch][cm.high])つまで\(totoOne.major)")
            for i in 0...managment.judge[cm.drawMatch][cm.high] - 1{
                for match in 0...managment.match.count - 1{
                    let str1 =  String(format: "%02d",match + 1)
                    let str2 = String(totoOne.major[i].suffix(2))
                    if str1 == str2{
                        managment.bed[match][cm.draw] = 1
                    }
                }
            }
        }
        // MARK:上記のほか、ダブりなどで欠落が起きた試合は引き分けで埋める
        let go = managment.judge[cm.majorWin][cm.high] +  managment.judge[cm.minorWin][cm.high] + managment.judge[cm.drawMatch][cm.high]
        if go > 0{
            for match in 0...managment.match.count - 1{
                if managment.bed[match] == Array<Int>(repeating: 0,count:3){
                    //  print("totoOne.major補充 試合No.\(match + 1)")
                    managment.bed[match][cm.draw] = 2
                }
            }
        }
        
        for match in 0...managment.match.count - 1{
            for master in 0...ct.master - 1{
                totoOne.mark[match][master] = replaceMark(mark: totoOne.mark[match][master])
            }
        }
    
        var _  = multScreenMark()

    }
    
    func multScreenMark(){
        var Count:Int = 0
        multSCreen.mark = Array<Int>(repeating: 0,count:5)
        for i in managment.bed {
            Count = 0
            for j in i {
                if j > 0 {
                    Count += 1
                }
            }
            if Count == 1{
                multSCreen.mark[ms.single] += 1
            }else if Count == 2{
                multSCreen.mark[ms.double] += 1
            }else if Count == 3{
                multSCreen.mark[ms.triple] += 1
            }
        }
        if multSCreen.mark[ms.single] == 0 && multSCreen.mark[ms.double] == 0 && multSCreen.mark[ms.triple] == 0{
            multSCreen.mark[ms.multi] = 0
        }else{
            multSCreen.mark[ms.multi] = Int(Int32(2 ^^ multSCreen.mark[ms.double]) * Int32(3 ^^ multSCreen.mark[ms.triple]))
        }
    }
}

