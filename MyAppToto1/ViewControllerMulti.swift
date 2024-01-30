//
//  ViewControllerMulti.swift
//  totoVer1.0.1
//
//  Created by 岩田嘉吉 on 2017/05/19.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//

import Cocoa

class ViewControllerMulti: NSViewController, NSTableViewDataSource {
    @IBOutlet weak var voteView: NSTableView!
    @IBOutlet weak var checkMatrix: NSMatrix!
    @IBOutlet weak var radioButton: NSMatrix!
    @IBOutlet weak var judgeMatrix: NSMatrix!
    @IBOutlet weak var lowPrizeMatrix: NSMatrix!
    @IBOutlet weak var highPrizeMatrix: NSMatrix!
    @IBOutlet weak var countMatrix: NSMatrix!
    @IBOutlet weak var minimumPrizeLabel: NSTextField!
    @IBOutlet weak var maximumPrizeLabel: NSTextField!
    @IBOutlet weak var totalLabelMatrix: NSMatrix!
    @IBOutlet weak var multiUchiwakeView: NSTableView!
    @IBOutlet weak var voteDetailsMatrix: NSMatrix!
    @IBOutlet weak var announcementText: NSTextField!  
    @IBOutlet weak var prizeMoneyLabl1: NSTextField!
    @IBOutlet weak var prizMoneyLabel2: NSTextField!
    @IBOutlet weak var yPosOberLabel: NSTextField!
    @IBOutlet weak var yPosTopLabel: NSTextField!
    @IBOutlet weak var yPosMidleLabel: NSTextField!
    @IBOutlet weak var xPosMidleLabel: NSTextField!
    @IBOutlet weak var xPosTopLabel: NSTextField!
    @IBOutlet weak var xPosOverLabel: NSTextField!
    @IBOutlet weak var spanLabel: NSTextField!
    @IBOutlet weak var zeroPointLabel: NSTextField!
    @IBOutlet weak var saleLabel: NSTextField!
    @IBOutlet weak var stampLabel: NSTextField!
    
    @IBOutlet weak var timerLabel: NSTextField!
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do view setup here.
        saleLabel.stringValue = "第" + String(homeScreen.user[ch.sale]) + "回"
        multSCreen.stamp += 1
        stampLabel.intValue = Int32(multSCreen.stamp)
        let userDefaults = UserDefaults.standard
        if  userDefaults.object(forKey: "judgeArray") != nil {
            managment.userDefault = userDefaults.array(forKey: "judgeArray")  as! Array<Int>
            managment.setJudge()
        }
        if generatefirstOrder.judgmentOnOff == cg.off{
            radioButton.setState(1, atRow: 0, column: 1)
        }
        let strs =  ["一等推定金額","本命","対抗","引き分け","ホーム","アウエー","穴15~25%","穴   ~15%"]
        for str in 0...strs.count - 1{
            judgeMatrix.cells[str].title = strs[str]
        }
        announcementText.textColor = NSColor.black
        if homeScreen.matchResult != Array<Int>(repeating: 0,count:13){
            announcementText.textColor = NSColor.red
        }
        for i in 0...managment.judge.count - 1{
            judgeMatrix.cells[i].doubleValue = Double(managment.judge[i][cm.judge])
        }
    
        var _ = displayPush()
        var _ = displayJudge()
       
        var bed = 0
        for matchNo in  0...managment.match.count - 1{
            for j in 0...2{
                bed += managment.bed[matchNo][j]
            }
        }
        if bed == 0{
            var _ = displayTeam()
        }
    
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    }

    override func viewWillDisappear () {
        timer.invalidate()
    }
    
    @objc func update(tm: Timer) {
        if stampLabel.intValue == Int32(multSCreen.stamp){
            if totoOfficialSiteDownLoad(sale: String(format: "%04d",homeScreen.user[ch.sale])) {
                voteView.reloadData()
                let vote = separateComma(num: (managment.vote[0][0] + managment.vote[0][1] + managment.vote[0][2]) * 100)
                timerLabel.stringValue = "※ " + getNowClockString() + " 現在の売上は、" + vote + "円です。"
            }
            if multSCreen.notice == 0{
                multSCreen.noticeDisp = managment.rateDisp
            }
        }
    }
    
    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd' 'HH:mm"
        let now = Date()
        return formatter.string(from: now)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView.tag == 0 {
            return managment.match.count
        }
        if tableView.tag == 1 {
            return multSCreen.noticeDisp.count
        }
        if tableView.tag == 2 {
            return multSCreen.aggregate.count
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
                    return multSCreen.noticeDisp[row][0]
                } else if(tcol.identifier.rawValue == "DRAW") {
                    return multSCreen.noticeDisp[row][1]
                }else if(tcol.identifier.rawValue == "AWE") {
                    return multSCreen.noticeDisp[row][2]
                }
            }
        }
    
        
        if tableView.tag == 2{
            if let tcol = tableColumn {
                if(tcol.identifier.rawValue == "HOME") {
                    return multSCreen.aggregate[row][0]
                } else if(tcol.identifier.rawValue == "DRAW") {
                    return multSCreen.aggregate[row][1]
                }else if(tcol.identifier.rawValue == "AWE") {
                    return multSCreen.aggregate[row][2]
                }
            }
        }
        
        return 0
    }
    
    @IBAction func radioButtonPushed(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        guard let cell = matrix.selectedCell() else {
            return
        }
        
        if cell.title == "有効" {
            generatefirstOrder.judgmentOnOff = cg.on
        }else{
            generatefirstOrder.judgmentOnOff = cg.off
        }
    }
    
    @IBAction func checkBox(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        let row = matrix.selectedRow
        managment.judge[row][cm.judge] = Int((sender as AnyObject).doubleValue)

        managment.setUserDefault()
        UserDefaults.standard.set(managment.userDefault, forKey: "judgeArray")
    }
    
    @IBAction func judgeLow(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        let row = matrix.selectedRow
        
        let mixedString = lowPrizeMatrix.cells[row].stringValue
        let splitNumbers = (mixedString.components(separatedBy: NSCharacterSet.decimalDigits.inverted))
        let number = splitNumbers.joined()
        managment.judge[row][cm.low] = Int(number)!
        lowPrizeMatrix.cells[row].stringValue = number
        
        managment.setUserDefault()
        UserDefaults.standard.set(managment.userDefault, forKey: "judgeArray")
    }
    
    @IBAction func judgeHigh(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        let row = matrix.selectedRow
        
        if highPrizeMatrix.cells[cm.prize].stringValue == ""{
            highPrizeMatrix.cells[cm.prize].stringValue = "0"
        }
        
        let mixedString = highPrizeMatrix.cells[row].stringValue
        let splitNumbers = (mixedString.components(separatedBy: NSCharacterSet.decimalDigits.inverted))
        let number = splitNumbers.joined()
        managment.judge[row][cm.high] = Int(number)!
        highPrizeMatrix.cells[row].stringValue = number
        
         if managment.judge[cm.prize][cm.high] == 0{
            let value: Int = Int(((Double(homeScreen.user[ch.prospectsSales]) * 0.5 * 0.7 + Double(homeScreen.user[ch.carryOver])) / 10000))
            managment.judge[cm.prize][cm.high] = value
            highPrizeMatrix.cells[cm.prize].intValue = Int32(value)
         }
        
        managment.setUserDefault()
        UserDefaults.standard.set(managment.userDefault, forKey: "judgeArray")
    }
    
    @IBAction func search(_ sender: Any) {
        guard stampLabel.intValue == Int32(multSCreen.stamp) else {
            print("Scrapped screen")
            return
        }
        guard (multSCreen.mark[ms.single] + multSCreen.mark[ms.double] + multSCreen.mark[ms.triple]) == 13 && homeScreen.user[ch.prospectsSales] > 0  else {
            firstOrderTickets.removeAll()
            return
        }
   
        singleScreen.stamp += 1
        checkScreen.stamp += 1
        buyTickets.removeAll()
        multiView.xPosTopValue = Int(Double(homeScreen.user[ch.prospectsSales]) * 0.5 * 0.7 / 10000)
        var _ = generatefirstOrderTicket()
        multiUchiwakeView.reloadData()
        multiView.goDraw = cd.erase
        loadView()
        var point = 0
        var x1 = 0
        var x2 = 0
        var y1 = 0
        var y2 = 0
        var barCell = [0,0,0,0]
        multiView.bar1.removeAll()
        multiView.bar2.removeAll()
        for i in 0...multiView.xPosOver - 1{
            multiView.frequency1[i] = 0
            multiView.frequency2[i] = 0
        }
        //  MARK:subView表示用に圧縮前のデータの度数分布、棒データを記録
        for i in 0...multiView.sample1.count - 1{
            if  multiView.sample1[i]  >  multiView.xPosTopValue {
                point = multiView.xPosTop + 15
            }else{
                point = multiView.xPosTop * multiView.sample1[i] / multiView.xPosTopValue + 1
            }
            multiView.frequency1[point] += 1
        }
        let sortedIntArray = multiView.frequency1.sorted { $0 > $1 }
        multiView.yPosTopValue = 1
        if sortedIntArray[1] > 1{
            multiView.yPosTopValue = sortedIntArray[1]
        }
        for i in 0...multiView.xPosOver - 1 {
            x1 = i
            y1 = 0
            x2 = i
            y2 = multiView.frequency1[i] *  multiView.yPosTop / multiView.yPosTopValue
            if  y2 > multiView.yPosOver{  //  微調整a
                y2 = multiView.yPosOver - 5
            }
            //  print("multiView.frequency1[\(i)] \(multiView.frequency1[i]) multiView.yPosTop\(multiView.yPosTop) / multiView.yPosTopValue \(multiView.yPosTopValue) y2 \(y2)")
            barCell = [x1,y1,x2,y2]
            multiView.bar1.append(barCell)
        }
        //  MARK:subView表示用に圧縮後のデータの度数分布、棒データを記録
        point = 0
        if multiView.sample2.count > 0 {
            for i in 0...multiView.sample2.count - 1{
                if  multiView.sample2[i] >  multiView.xPosTopValue {
                    point = multiView.xPosTop + 15
                }else{
                    point = multiView.xPosTop * multiView.sample2[i] / multiView.xPosTopValue +  1
                }
                multiView.frequency2[point] += 1
                    
            }
            for i in 1...multiView.xPosOver - 1 {
                x1 = i
                y1 = 0
                x2 = i
                y2 = multiView.frequency2[i] *  multiView.yPosTop / multiView.yPosTopValue
                if  y2 > multiView.yPosOver{
                    y2 = multiView.yPosOver - 5
                }
                barCell = [x1,y1,x2,y2]
                multiView.bar2.append(barCell)
            }
        }
        //  MARK:subViewの目盛りを表示
        multiView.goDraw = cd.drawBarChart
        loadView()
        
        multiView.xPosMiddle = Int(multiView.xPosTopValue / 2)
        multiView.yPosMiddle = Int(multiView.yPosTopValue / 2)
        if sortedIntArray[0] > multiView.yPosTopValue{
            yPosOberLabel.intValue = Int32(sortedIntArray[0])
        }
        yPosTopLabel.intValue = Int32(multiView.yPosTopValue)
        if multiView.yPosMiddle >= 1{
            let amari: Int  = multiView.yPosTopValue % 2
            if amari == 0{
                yPosMidleLabel.intValue = Int32(multiView.yPosMiddle)
            }else{
            yPosMidleLabel.stringValue = String(multiView.yPosMiddle) + ".5"
            }
        }
        xPosMidleLabel.intValue = Int32(multiView.xPosMiddle)
        xPosTopLabel.intValue = Int32(multiView.xPosTopValue)
        xPosOverLabel.stringValue = ""
        if multSCreen.maximumPrize > multiView.xPosTopValue{
            xPosOverLabel.intValue = Int32(multSCreen.maximumPrize)
        }
        spanLabel.stringValue = "X軸 " + separateComma(num: Int(Double(multiView.xPosTopValue) * 10000.0 / Double(multiView.xPosTop)))  + "円 / Point"
        zeroPointLabel.intValue = 0
        for cell in 0...managment.judge.count - 1{
            countMatrix.cells[cell].intValue = Int32(managment.judge[cell][cm.count])
        }
        prizeMoneyLabl1.stringValue = "Prize money"
        prizMoneyLabel2.stringValue = "〜"
        minimumPrizeLabel.intValue = Int32(multSCreen.minimumPrize)
        maximumPrizeLabel.intValue = Int32(multSCreen.maximumPrize)
        voteDetailsMatrix.cells[4].intValue = Int32(multSCreen.mark[ms.afterCompression])
        
    }
   
    @IBAction func clear(_ sender: Any) {
        //   MARK:画面クリア
        guard stampLabel.intValue == Int32(multSCreen.stamp) else {
            print("Scrapped screen")
            return
        }
        multiView.goDraw = cd.erase
        for str in 0...2{
            totalLabelMatrix.cells[str].title = ""
        }
        multSCreen.mark = Array<Int>(repeating: 0,count:5)
        multSCreen.aggregate = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
        managment.bed = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
        loadView()
        announcementText.stringValue = ""
        var _ = displayTeam()
    }
 
    @IBAction func selectCheckMatrix(_ sender: Any) {
        // MARK:ボタンタイトルの表示とmarkを記録
        guard stampLabel.intValue == Int32(multSCreen.stamp) else {
            print("Scrapped screen")
            return
        }
        
        for cell in 0...3{
            voteDetailsMatrix.cells[cell].intValue = 0
        }
            
        guard let matrix = sender as? NSMatrix else {
        return
            }
        let match = matrix.selectedRow
        let mark  = matrix.selectedColumn
            
        managment.bed[match][mark] += 1
        if managment.bed[match][mark] > 2{
            managment.bed[match][mark] = 0
        }
        var Count:Int = 0
        multSCreen.mark =  Array<Int>(repeating: 0,count:5)
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
            
        loadView()
        if (multSCreen.mark[ms.single] + multSCreen.mark[ms.double] + multSCreen.mark[ms.triple]) == 13 {
            multSCreen.mark[ms.multi] = Int(Int32(2 ^^ multSCreen.mark[ms.double]) * Int32(3 ^^ multSCreen.mark[ms.triple]))
            for cell in 0...3{
                voteDetailsMatrix.cells[cell].intValue = Int32(multSCreen.mark[cell])
            }
        }
    }
    
    
    //  MARK:検索条件を表示する
    func displayJudge(){
        for i in 0...managment.judge.count - 1{
            lowPrizeMatrix.cells[i].intValue = Int32(managment.judge[i][cm.low])
            highPrizeMatrix.cells[i].intValue = Int32(managment.judge[i][cm.high])
        }
        for i in 0...multSCreen.mark.count - 1{
            voteDetailsMatrix.cells[i].intValue = Int32(multSCreen.mark[i])
        }
    }
    
    //  MARK:   ボタンタイトルをセットする
    func displayPush(){
        for match in 0...managment.match.count - 1{
            for bed in 0...2{
                if managment.bed[match][bed] == 1{
                    //checkMatrix.cell(atRow: match, column: bed)?.title = "○"
                    checkMatrix.cell(atRow: match, column: bed)?.image = NSImage(named: "blackBall")
                }else if managment.bed[match][bed] == 2{
                    //checkMatrix.cell(atRow: match, column: bed)?.title = "◎"
                    checkMatrix.cell(atRow: match, column: bed)?.image = NSImage(named: "redBall")
                }else{
                    checkMatrix.cell(atRow: match, column: bed)?.title = ""
                    checkMatrix.cell(atRow: match, column: bed)?.image = NSImage(named: "white")
                }
            }
        }
    }
   
    func displayTeam() {
        for match in 0...managment.match.count - 1{
            for bed in 0...2{
                if bed == 0{
                    checkMatrix.cell(atRow: match, column: bed)?.title = managment.match[match][1]
                }else if bed == 1{
                    checkMatrix.cell(atRow: match, column: bed)?.title = "引分"
                }else{
                    checkMatrix.cell(atRow: match, column: bed)?.title = managment.match[match][2]
                }
            }
        }
    }

}
