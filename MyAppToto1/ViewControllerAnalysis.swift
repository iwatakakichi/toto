//
//  Analysis.swift
//  totoVer1.0.1
//
//  Created by 岩田嘉吉 on 2017/05/29.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//

import Cocoa

class ViewControllerAnalysis: NSViewController, NSTableViewDataSource  {

    @IBOutlet weak var upperSideView: NSTableView!
    @IBOutlet weak var lowerSideView: NSTableView!
    @IBOutlet weak var judgeMatrix: NSMatrix!
    @IBOutlet weak var lowPrizeMatrix: NSMatrix!
    @IBOutlet weak var highPrizeMatrix: NSMatrix!
    @IBOutlet weak var countMatrix: NSMatrix!
    @IBOutlet weak var pageLabel: NSTextField!
    @IBOutlet weak var remarksColumnLabel: NSTextField!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var yearText: NSTextField!
    @IBOutlet weak var announcementLabel: NSTextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        resultScreen.saveUser = homeScreen.user
        
        if resultScreen.labelYear == 0{
            let now = Date()
            let cal = Calendar.current
            let dataComps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: now)
            resultScreen.labelYear = dataComps.year!
        }
        yearText.stringValue = String(resultScreen.labelYear)
        announcementLabel.stringValue = "ちょっと時間がかかりますよ！\n目安１分前後ですね。"
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: "judgeArray") != nil) {
            managment.userDefault = userDefaults.array(forKey: "judgeArray")  as! Array<Int>
            managment.setJudge()
        }
        let strs =  ["一等推定金額","本命","対抗","引き分け","ホーム","アウエー","穴15~25%","穴   ~15%"]
        for str in 0...strs.count - 1{
            judgeMatrix.cells[str].title = strs[str]
        }
        for i in 0...managment.judge.count - 1{
            judgeMatrix.cells[i].doubleValue = Double(managment.judge[i][cm.judge])
        }
        resultScreen.page = 1
        pageLabel.intValue = Int32(resultScreen.page)
        
        for i in 0...managment.judge.count - 1{
            lowPrizeMatrix.cells[i].intValue = Int32(managment.judge[i][cm.low])
            highPrizeMatrix.cells[i].intValue = Int32(managment.judge[i][cm.high])
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        if tableView.tag == 0 {
            return cr.displayRowSize
        }
        if tableView.tag == 1 {
            return cr.displayRowSize
        }
         return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        if tableView.tag == 0{
            if let tcol = tableColumn {
                if(tcol.identifier.rawValue == "result0") {
                    return resultScreen.upperSideTable[row][0]
                }else if(tcol.identifier.rawValue == "result1") {
                    return resultScreen.upperSideTable[row][1]
                }else if(tcol.identifier.rawValue == "result2") {
                    return resultScreen.upperSideTable[row][2]
                }else if(tcol.identifier.rawValue == "result3") {
                    return resultScreen.upperSideTable[row][3]
                }else if(tcol.identifier.rawValue == "result4") {
                    return resultScreen.upperSideTable[row][4]
                }else if(tcol.identifier.rawValue == "result5") {
                    return resultScreen.upperSideTable[row][5]
                }else if(tcol.identifier.rawValue == "result6") {
                    return resultScreen.upperSideTable[row][6]
                }else if(tcol.identifier.rawValue == "result7") {
                    return resultScreen.upperSideTable[row][7]
                }else if(tcol.identifier.rawValue == "result8") {
                    return resultScreen.upperSideTable[row][8]
                }else if(tcol.identifier.rawValue == "result9") {
                    return resultScreen.upperSideTable[row][9]
                }else if(tcol.identifier.rawValue == "result10") {
                    return resultScreen.upperSideTable[row][10]
                }else if(tcol.identifier.rawValue == "result11") {
                    return resultScreen.upperSideTable[row][11]
                }
            }
        }
    
        if tableView.tag == 1{
            if let tcol = tableColumn {
                if(tcol.identifier.rawValue == "result0") {
                    return resultScreen.lowerSideTable[row][0]
                }else if(tcol.identifier.rawValue == "result1") {
                    return resultScreen.lowerSideTable[row][1]
                }else if(tcol.identifier.rawValue == "result2") {
                    return resultScreen.lowerSideTable[row][2]
                }else if(tcol.identifier.rawValue == "result3") {
                    return resultScreen.lowerSideTable[row][3]
                }else if(tcol.identifier.rawValue == "result4") {
                    return resultScreen.lowerSideTable[row][4]
                }else if(tcol.identifier.rawValue == "result5") {
                    return resultScreen.lowerSideTable[row][5]
                }else if(tcol.identifier.rawValue == "result6") {
                    return resultScreen.lowerSideTable[row][6]
                }else if(tcol.identifier.rawValue == "result7") {
                    return resultScreen.lowerSideTable[row][7]
                }else if(tcol.identifier.rawValue == "result8") {
                    return resultScreen.lowerSideTable[row][8]
                }else if(tcol.identifier.rawValue == "result9") {
                    return resultScreen.lowerSideTable[row][9]
                }else if(tcol.identifier.rawValue == "result10") {
                    return resultScreen.lowerSideTable[row][10]
                }else if(tcol.identifier.rawValue == "result11") {
                    return resultScreen.lowerSideTable[row][11]
                }
            }
        }
        return 0
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

    @IBAction func displaySwitching(_ sender: Any) {
        if resultScreen.choice == cr.mark {
            for j in 0...cr.displayColumunSize - 1 {
                for i in 0...firstOrderTicket.mark.count - 1 {
                    resultScreen.upperSideTable[i + 1][j] = resultScreen.teamTable[i][j]
                    resultScreen.lowerSideTable[i + 1][j] = resultScreen.teamTable[i][j + cr.displayColumunSize]
                }
            }
            resultScreen.choice = cr.team
        }else  if resultScreen.choice == cr.team {
            for j in 0...cr.displayColumunSize - 1 {
                for i in 0...firstOrderTicket.mark.count - 1 {
                    resultScreen.upperSideTable[i + 1][j] = resultScreen.rateTable[i][j]
                    resultScreen.lowerSideTable[i + 1][j] = resultScreen.rateTable[i][j + cr.displayColumunSize]
                }
            }
            resultScreen.choice = cr.rate
        }else  if resultScreen.choice == cr.rate {
            for j in 0...cr.displayColumunSize - 1{
                for i in 0...firstOrderTicket.mark.count - 1 {
                    resultScreen.upperSideTable[i + 1][j] = resultScreen.markTable[i][j]
                    resultScreen.lowerSideTable[i + 1][j] = resultScreen.markTable[i][j + cr.displayColumunSize]
                }
            }
            resultScreen.choice = cr.mark
        }
        upperSideView.reloadData()
        lowerSideView.reloadData()
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
        let mixedString = highPrizeMatrix.cells[row].stringValue
        let splitNumbers = (mixedString.components(separatedBy: NSCharacterSet.decimalDigits.inverted))
        let number = splitNumbers.joined()
        managment.judge[row][cm.high] = Int(number)!
        highPrizeMatrix.cells[row].stringValue = number
        
        managment.setUserDefault()
        UserDefaults.standard.set(managment.userDefault, forKey: "judgeArray")
    }
    
    @IBAction func calendarYear(_ sender: Any) {
        resultScreen.labelYear = Int(yearText.intValue)
        resultScreen.page = 1
        pageLabel.stringValue = String(resultScreen.page)
        resultScreen.choice = 0
    }
    
    @IBAction func beforePage(_ sender: Any) {
        let maximumPage = Int((resultScreen.saleTable.count - 1) / 24) + 1
        if resultScreen.page > 1 && resultScreen.saleTable.count > 0{
            resultScreen.page -= 1
            pageLabel.stringValue = String(resultScreen.page) + "/" + String(maximumPage)
            resultScreen.choice = 0
        }
    }
    
    @IBAction func afterPage(_ sender: Any) {
        let maximumPage = Int((resultScreen.saleTable.count - 1) / 24) + 1
        if resultScreen.page < maximumPage && resultScreen.saleTable.count > 0{
            resultScreen.page += 1
            pageLabel.stringValue = String(resultScreen.page) + "/" + String(maximumPage)
            resultScreen.choice = 0
        }
    }
   
    @IBAction func run(_ sender: Any) {
        //  ボタンのクリックなどでアクションが呼ばれると仮定して
        //  処理中はそれを無効化する
        //  let control = sender as? NSControl
        //  control?.isEnable = false
        
        // プログレスバーをアニメートしたいので別スレッドで処理
        DispatchQueue.global().async {
            self.display() {
                // 別スレッドが終わったらこのクロージャが呼ばれる
                // 描画にかかわりのある処理はメインスレッド上で実行しなければならない
                DispatchQueue.main.async {
                    // 有効に戻す
                    // control?.isEnable = true
                }
            }
        }
        
    }
    
    private func display(_ completionHandler: () -> Void) {
        
        //  step1   initialize
        resultScreen.bothSideTable = [[String]](repeating: [String](repeating: "", count: 24),count: 28)
        resultScreen.upperSideTable =  [[String]](repeating: [String](repeating: "", count: 12),count: 28)
        resultScreen.lowerSideTable =  [[String]](repeating: [String](repeating: "", count: 12),count: 28)
        resultScreen.markTable =  [[String]](repeating: [String](repeating: "", count: 24),count: 13)
        resultScreen.rateTable = [[String]](repeating: [String](repeating: "", count: 24),count: 13)
        resultScreen.teamTable = [[String]](repeating: [String](repeating: "", count: 24),count: 13)
        
        for i in 0...managment.judge.count - 1{
            managment.judge[i][cm.count] = 0
        }
        resultScreen.conditionClearCount = 0
        DispatchQueue.main.async {
            for i in 0...managment.judge.count - 1{
                self.countMatrix.cells[i].stringValue = ""
            }
            self.announcementLabel.stringValue = "ちょっと時間がかかりますよ！\n目安１分前後ですね。"
        }
        //  step2   開催回次を把握
        let _  = totoOfficialSiteDownLoad(sale: String(format: "%04d",homeScreen.user[ch.sale]))
        var url = URL(string: "http://www.toto-dream.com/dci/I/IPB/IPB01.do?op=initLotResultLsttoto")!
        if resultScreen.stockYear != resultScreen.labelYear{
            resultScreen.stockYear = resultScreen.labelYear
            url = URL(string: "https://store.toto-dream.com/dcs/subos/screen/pi04/spin011/PGSPIN01101LnkSeasonLotResultLsttoto.form?popupDispDiv=disp&meetingFiscalYear=" + String(resultScreen.labelYear))!
            //  print("resultScreen.stockYear \(resultScreen.stockYear) resultScreen.labelYear \(resultScreen.labelYear)")
            let ss = HttpClientImpl()
            let t = ss.execute(request: URLRequest(url: url))
            let getData: NSString = NSString(data: t.0! as Data, encoding: String.Encoding.utf8.rawValue)!
            let myStr = getData as String
        
            var s1:Array<String> =  Array<String>(repeating: "",count:10)
            var temp = Array<Int>()
            let keyWord = ["h","o","l","d","C","n","t","I","d","="]
            var stack = 0
            var str = ""
            resultScreen.saleTable.removeAll()
        
            for c in myStr {
            
                s1[0] = s1[1]
                s1[1] = s1[2]
                s1[2] = s1[3]
                s1[3] = s1[4]
                s1[4] = s1[5]
                s1[5] = s1[6]
                s1[6] = s1[7]
                s1[7] = s1[8]
                s1[8] = s1[9]
                s1[9] = String(c)
            
                if s1 == keyWord{
                    stack = 0
                }
                stack += 1
                if stack > 1 && stack <= 5{
                    str = str + String(c)
                }
                if stack == 5{
                    if isOnlyNumber(str){
                        temp.append(Int(str)!)
                    }
                    str = ""
                }
            }
       
            for i in 0...temp.count - 1 {
                DispatchQueue.main.async { self.progressBar.doubleValue = Double(i + 1) / Double(temp.count) }
                let read1 = lotteryResultDownLoad(sale: temp[i])
                if read1 == true{
                    resultScreen.saleTable.append(temp[i])
                }
            }
       }
        
        resultScreen.saleTable.sort { $0 < $1 }
        
        for i in 0...resultScreen.salezDisplayTable.count - 1{
            if (resultScreen.page - 1) * cr.displayMaximumSize + i <= resultScreen.saleTable.count - 1{
                resultScreen.salezDisplayTable[i] = resultScreen.saleTable[(resultScreen.page - 1) * cr.displayMaximumSize + i]
            }else{
                resultScreen.salezDisplayTable[i] = 0
            }
        }
 
        // step3    表示データセット
        
        for i in 0...cr.displayMaximumSize - 1 {
            // 描画にかかわりのある処理はメインスレッド上で実行しなければならない
            DispatchQueue.main.async { self.progressBar.doubleValue = Double(i + 1) / Double(cr.displayMaximumSize) }
            
            if resultScreen.salezDisplayTable[i] > 0{
                homeScreen.user[ch.sale] = resultScreen.salezDisplayTable[i]
                homeScreen.matchResult =  Array<Int>(repeating:0,count:13)
                let read1  = totoOfficialSiteDownLoad(sale: String(format: "%04d",resultScreen.salezDisplayTable[i]))
                let read2  = lotteryResultDownLoad(sale: resultScreen.salezDisplayTable[i])
                if read1 && read2{
                    homeScreen.user[ch.prospectsSales] = (managment.vote[0][cm.home] + managment.vote[0][cm.draw] + managment.vote[0][cm.away]) * 100
                    homeScreen.user[ch.carryOver] = 0
                    for match in 0...homeScreen.matchResult.count - 1 {   //  1,0,2 をマーク1,2,3に仮置き
                        homeScreen.matchResult[match] = Int(String(homeScreen.matchResult[match]).replacingOccurrences(of: "2", with: "3"))!
                        homeScreen.matchResult[match] = Int(String(homeScreen.matchResult[match]).replacingOccurrences(of: "0", with: "2"))!
                    }
                    generatefirstOrder.mark = homeScreen.matchResult
                    let x = editFirstOrderProcessing()
                    let (judge,_,judgmentResult) = judgeFirstOrderProcessing(probability: x)
                    
                    managment.judge[cm.prize][cm.count] += judge[cm.prize] as! Int
                    managment.judge[cm.majorWin][cm.count] += judge[cm.majorWin] as! Int
                    managment.judge[cm.minorWin][cm.count] += judge[cm.minorWin] as! Int
                    managment.judge[cm.drawMatch][cm.count] += judge[cm.drawMatch] as! Int
                    managment.judge[cm.homeWin][cm.count] += judge[cm.homeWin] as! Int
                    managment.judge[cm.awayWin][cm.count] += judge[cm.awayWin] as! Int
                    managment.judge[cm.under25][cm.count] += judge[cm.under25] as! Int
                    managment.judge[cm.under15][cm.count] += judge[cm.under15] as! Int
                    if judgmentResult == true {
                        resultScreen.conditionClearCount += 1
                    }
                    resultScreen.bothSideTable[0][i] = "第" + String(resultScreen.salezDisplayTable[i]) + "回"
                    for match in 0...firstOrderTicket.mark.count - 1{
                        resultScreen.bothSideTable[match + 1][i] = String(firstOrderTicket.mark[match])
                    }
                    for j in 0...firstOrderTicket.rank.count - 1 {
                        var str1 = "oooooooo"   //  13桁表示したいが表示スペースに余裕がない
                        var str2 = "________"
                        switch firstOrderTicket.rank[j] {
                        case 0:
                            str1 = ""
                        case 1,2,3,4,5,6,7,8:
                            str1 = String(str1.prefix(firstOrderTicket.rank[j]))
                            str2 = String(str2.prefix(8 - firstOrderTicket.rank[j]))
                        default:
                            str2 = ""
                        }
                        resultScreen.bothSideTable[j + 14][i] = str1 + str2
                    }
                    resultScreen.bothSideTable[21][i] = resultScreen.bothSideTable[21][i].replacingOccurrences(of: "o", with: "•")
                    resultScreen.bothSideTable[22][i] = resultScreen.bothSideTable[22][i].replacingOccurrences(of: "o", with: "•")
                    resultScreen.bothSideTable[23][i] = separateComma(num: firstOrderTicket.prize * 10000)
                    resultScreen.bothSideTable[24][i] = String(firstOrderTicket.winner)
                    resultScreen.bothSideTable[25][i] = separateComma(num: firstOrderTicket.difficulty)
                    resultScreen.bothSideTable[26][i] = String(firstOrderTicket.major) + "-" + String(firstOrderTicket.minor) + "-" + String(firstOrderTicket.draw)
                    resultScreen.bothSideTable[27][i] = separateComma(num: homeScreen.prize)
                    
                    for match in 0...firstOrderTicket.mark.count - 1 {
                        resultScreen.markTable[match][i] = String(firstOrderTicket.mark[match])
                        resultScreen.rateTable[match][i] =  managment.rateDisp[match][generatefirstOrder.mark[match] - 1]
                        
                        if managment.match[match][cm.homeTeam].count == 1{      //  1文字チーム名の表示位置を中央に調整
                            managment.match[match][cm.homeTeam] = "　" + managment.match[match][cm.homeTeam] + "　"
                        }
                        if managment.match[match][cm.awayTeam].count == 1{
                            managment.match[match][cm.awayTeam] = "　" + managment.match[match][cm.awayTeam] + "　"
                        }
                        if managment.match[match][cm.homeTeam].count == 2{
                            managment.match[match][cm.homeTeam] = managment.match[match][cm.homeTeam] + "　"
                        }
                        if managment.match[match][cm.awayTeam].count == 2{
                            managment.match[match][cm.awayTeam] = "　" + managment.match[match][2]
                        }
                        resultScreen.teamTable[match][i] = managment.match[match][cm.homeTeam] + "×" + managment.match[match][cm.awayTeam]
                    }
                }
            }
            
        }
        
        //  step4   後始末
        
        for i in 0...cr.displayRowSize - 1{
            for j in 0...cr.displayColumunSize - 1 {
                resultScreen.upperSideTable[i][j] = resultScreen.bothSideTable[i][j]
            }
        }
        
        for i in 0...cr.displayRowSize - 1{
            for j in 0...cr.displayColumunSize - 1 {
                resultScreen.lowerSideTable[i][j] = resultScreen.bothSideTable[i][j + 12]
            }
        }

        
        DispatchQueue.main.async {
            //  MARK:集計条件表
            for i in 0...managment.judge.count - 1{
                self.lowPrizeMatrix.cells[i].stringValue = transfromFromZeroToBlank(inDt:managment.judge[i][cm.low])
                self.highPrizeMatrix.cells[i].stringValue = transfromFromZeroToBlank(inDt:managment.judge[i][cm.high])
            }
            for i in 0...managment.judge.count - 1{
                self.countMatrix.cells[i].intValue = Int32(managment.judge[i][cm.count])
            }
            self.remarksColumnLabel.stringValue = ""
            self.remarksColumnLabel.stringValue = "条件をすべてクリア、" + String(resultScreen.conditionClearCount)
            let maximumPage = Int((resultScreen.saleTable.count - 1) / cr.displayMaximumSize) + 1
            self.pageLabel.stringValue = String(resultScreen.page) + "/" + String(maximumPage)
            var _ = managment.initialize()
            homeScreen.matchResult = Array<Int>(repeating: 0,count:13)
            checkScreen.result = Array<String>(repeating: "",count:28)
            homeScreen.user = resultScreen.saveUser
            
            self.upperSideView.reloadData()
            self.lowerSideView.reloadData()
            self.announcementLabel.stringValue = ""
        }
    
        // 処理が終わったら与えられた関数を実行する
        completionHandler()
    }
    
}
