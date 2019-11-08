//
//  ViewControllerCheck.swift
//  totoVer1.0.1
//
//  Created by 岩田嘉吉 on 2017/05/19.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//

import Cocoa

class ViewControllerCheck: NSViewController, NSTableViewDataSource   {
    
    @IBOutlet weak var teamView: NSTableCellView!
    @IBOutlet weak var resultView: NSTableView!
    @IBOutlet weak var mainView: NSTableView!
    @IBOutlet weak var pageNoLabel: NSTextField!
    @IBOutlet weak var buyCountLabel: NSTextField!
    @IBOutlet weak var markButton: NSButton!
    @IBOutlet weak var sortButton: NSButton!
    @IBOutlet weak var remarksColumnLabel: NSTextField!
    @IBOutlet weak var stampLabel: NSTextField!
    @IBOutlet weak var saleLabel: NSTextField!
    @IBOutlet weak var tousenImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        checkScreen.initialize()
        saleLabel.stringValue = "第" + String(homeScreen.user[ch.sale]) + "回"
        checkScreen.stamp += 1
        stampLabel.intValue = Int32(checkScreen.stamp)
        if homeScreen.matchResult != Array<Int>(repeating: 0,count:13){
            var _ = ticketsUpload()
            var _ = editDisplayRezalt()
            resultView.reloadData()
            var _ = checkupHit()
            checkScreen.sort = cc.hit
            sortButton.title  = "あたり"
            remarksColumnLabel.stringValue = "あたり"
        }
        
        buyCountLabel.intValue = Int32(buyTickets.count)
        if (buyTickets.count > 0) {
            checkScreen.pageNo = 1
            pageNoLabel.intValue = Int32(checkScreen.pageNo)
            var _ = checkScreenSort()
            var _ = limit10Pieces()
            var _ = displayCheckScreen()
            mainView.reloadData()
        }
        
        for ticket in buyTickets{
            if ticket.hit > 11{
                tousenImage.image = #imageLiteral(resourceName: "tousen")
            }
        }
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView.tag == 0 {
            return managment.match.count
        }
        if tableView.tag == 1 {
            return checkScreen.result.count
        }
        if tableView.tag == 2 {
            return checkScreen.display.count
        }
        if tableView.tag == 3 {
            return managment.rateDisp.count
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
                if(tcol.identifier.rawValue == "CHECK") {
                    return  checkScreen.result[row]
                }
            }
        }
        
        if tableView.tag == 2{
            if let tcol = tableColumn {
                if(tcol.identifier.rawValue == "Ticket0") {
                    return checkScreen.display[row][0]
                }else if(tcol.identifier.rawValue == "Ticket1") {
                    return checkScreen.display[row][1]
                }else if(tcol.identifier.rawValue == "Ticket2") {
                    return checkScreen.display[row][2]
                }else if(tcol.identifier.rawValue == "Ticket3") {
                    return checkScreen.display[row][3]
                }else if(tcol.identifier.rawValue == "Ticket4") {
                    return checkScreen.display[row][4]
                }else if(tcol.identifier.rawValue == "Ticket5") {
                    return checkScreen.display[row][5]
                }else if(tcol.identifier.rawValue == "Ticket6") {
                    return checkScreen.display[row][6]
                }else if(tcol.identifier.rawValue == "Ticket7") {
                    return checkScreen.display[row][7]
                }else if(tcol.identifier.rawValue == "Ticket8") {
                    return checkScreen.display[row][8]
                }else if(tcol.identifier.rawValue == "Ticket9") {
                    return checkScreen.display[row][9]
                }
            }
        }
        
        if tableView.tag == 3{
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
        return 0
    }

    @IBAction func start(_ sender: Any) {
        // MARK:最初のページへ
        guard stampLabel.intValue == Int32(checkScreen.stamp) else {
            print("Scrapped screen")
            return
        }

        if buyTickets.count  > 0{
            checkScreen.pageNo = 1
            pageNoLabel.intValue = Int32(checkScreen.pageNo)
            var _ = limit10Pieces()
            var _ = displayCheckScreen()
            mainView.reloadData()
        }
    }
    
    @IBAction func Before(_ sender: Any) {
        // MARK:１つ前のページへ
        guard stampLabel.intValue == Int32(checkScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if buyTickets.count  > 0{
            if checkScreen.pageNo > 1 {
                checkScreen.pageNo -= 1
                pageNoLabel.intValue = Int32(checkScreen.pageNo)
                var _ = limit10Pieces()
                var _ = displayCheckScreen()
                mainView.reloadData()
            }
        }
    }
    
    @IBAction func next(_ sender: Any) {
        // MARK:次のページへ
        guard stampLabel.intValue == Int32(checkScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if buyTickets.count  > 0 {
            if buyTickets.count > checkScreen.pageNo * 10 {
                checkScreen.pageNo += 1
                pageNoLabel.intValue = Int32(checkScreen.pageNo)
                var _ = limit10Pieces()
                var _ = displayCheckScreen()
                mainView.reloadData()
            }
        }
    }
    
    @IBAction func last(_ sender: Any) {
        // MARK:最後のページへ
        guard stampLabel.intValue == Int32(checkScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if buyTickets.count > 0 {
            checkScreen.pageNo = Int((buyTickets.count - 1) / 10) + 1
            pageNoLabel.intValue = Int32(checkScreen.pageNo)
            var _ = limit10Pieces()
            var _ = displayCheckScreen()
            mainView.reloadData()
        }
    }
    
    @IBAction func mark(_ sender: Any) {
        //  MARK:表示切り替え
        guard stampLabel.intValue == Int32(checkScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if buyTickets.count > 0 {
            if (checkScreen.choisu == cc.mark){
                checkScreen.choisu = 1
                if homeScreen.matchResult != Array<Int>(repeating: 0,count:13){
                    markButton.title  = "結果"
                }else{
                    markButton.title  = "投票率"
                    }
            }else if(checkScreen.choisu == cc.rezult){
                checkScreen.choisu = cc.team
                markButton.title  = "チーム"
            }else if(checkScreen.choisu == cc.team){
                checkScreen.choisu = cc.mark
                markButton.title  = "マーク"
            }
            var _ = limit10Pieces()
            var _ = displayCheckScreen()
            resultView.reloadData()
            mainView.reloadData()
        }
    }
    
    @IBAction func sort(_ sender: Any) {
        //  MARK:ソート
        guard stampLabel.intValue == Int32(checkScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if buyTickets.count > 0 {
            if(checkScreen.sort == cc.mainStream){
                checkScreen.sort = cc.hit
                sortButton.title  = "あたり"
                remarksColumnLabel.stringValue = "あたり"
            }else if(checkScreen.sort == cc.hit){
                checkScreen.sort = cc.difficulty
                sortButton.title  = "当選確率"
                remarksColumnLabel.stringValue = "あたり"
            }else if(checkScreen.sort == cc.difficulty){
                checkScreen.sort = cc.mainStream
                sortButton.title  = "◎の数"
                remarksColumnLabel.stringValue = "一押し◎の数"
            }
            var _ = checkScreenSort()
            var _ = limit10Pieces()
            var _ = displayCheckScreen()
            mainView.reloadData()
        }
    }
    
    @IBAction func dataDownLoad(_ sender: Any) {
        //  let formatter = DateFormatter()
        //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SSS"
        //  let now = Date()
        //  print("\(now) start TicketsDownload 関数")
        guard stampLabel.intValue == Int32(checkScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        let textFileName = "X-" + String(homeScreen.user[ch.sale]) + ".csv"
        var overlap = 0
        let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let targetTextFilePath = documentDirectoryFileURL?.appendingPathComponent(textFileName)
            
        var totoPS = [String: Array<Any>]()
        totoPS.removeAll()
        if homeScreen.matchResult == Array<Int>(repeating: 0,count:13){
            //  MARK:重複チェック（この処理は保険です。）
            for ticket in buyTickets {
                var key = ""
                for i in 0...ticket.mark.count - 1  {
                    key = key + String(ticket.mark[i])
                }
                let data = ticket.mark
                if let old = totoPS.updateValue(data, forKey: key) {
                    overlap += 1
                    print("更新前の値は \(old) でした")
                }
            }
            let alert = NSAlert()
            if buyTickets.count == 0{
                alert.messageText = "第" + String(homeScreen.user[ch.sale]) + "回、totoチケットを購入できません。"
                alert.informativeText = "　口数は、" + String(buyTickets.count) +
                        "口でした。購入データがありません。"
                alert.runModal()
            }else if overlap > 0{
                alert.messageText = "第" + String(homeScreen.user[ch.sale]) + "回、totoチケットを購入できません。"
                alert.informativeText = "　口数は、" + String(buyTickets.count) +
                        "口でした。例外が発生しました。システム管理者へ連絡して下さい。"
                alert.runModal()
            }else if buyTickets.count > 500{
                alert.messageText = "第" + String(homeScreen.user[ch.sale]) + "回、totoチケットを購入できません。"
                alert.informativeText = "　口数は、" + String(buyTickets.count) +
                                        "口でした。totoチケットの1枚当たりで購入できる口数の上限は最大500口です。" +
                                        "本アプリケーションプログラムにおいても上限をを500口、５万円に制限しています。"
                alert.runModal()
            }else{
                var text = ""
                for (_,testValue) in totoPS {
                    for match in 0...buyTicket.mark.count - 1  {
                        text = text + String(describing: testValue[match])  + ","
                    }
                    let initialText = String(text.prefix(text.count - 1))
                    text = initialText + "\r\n"    // totoPS用にwindowsの改行コードを使用する
                }
                do {
                    try text.write(to: targetTextFilePath!, atomically: true, encoding: String.Encoding.utf8)
                        let konyuString = separateComma(num: totoPS.count * 100)
                        let alert = NSAlert()
                        alert.messageText = "第" + String(homeScreen.user[ch.sale]) + "回購入金額は、" + konyuString + "円です。"
                        alert.informativeText = "購入データ " + "X-" + String(homeScreen.user[ch.sale]) + ".csv を、" + String(describing: targetTextFilePath) + "に保存しました。"
                        //  Windowsが利用できる方へ、X-" + String(homeScreen.user[ch.sale]) + ".csvはインターネット購入支援ソフト「totoPS」(widows用フリーソフト)で利用できます。"
                        alert.runModal()
                        homeScreen.user[ch.totoPs] = homeScreen.user[ch.sale]
                        UserDefaults.standard.set(homeScreen.user, forKey: "userArray")
                } catch let error as NSError {
                    print("TicketsDownload failed to write: \(error)")
                }
            }
        }
    }

    func editDisplayRezalt(){
        for match in 0...generatefirstOrder.mark.count - 1 {   //  1,0,2 をマーク1,2,3に仮置き
            generatefirstOrder.mark[match] = homeScreen.matchResult[match]
            generatefirstOrder.mark[match] = Int(String(generatefirstOrder.mark[match]).replacingOccurrences(of: "2", with: "3"))!
            generatefirstOrder.mark[match] = Int(String(generatefirstOrder.mark[match]).replacingOccurrences(of: "0", with: "2"))!
        }
        var _ = editFirstOrderProcessing()

        for match in 0...firstOrderTicket.mark.count - 1 {
            checkScreen.result[match] = String(firstOrderTicket.mark[match])
        }
        for i in 0...firstOrderTicket.rank.count - 1 {
            var str1 = "oooooooo"
            var str2 = "________"
            switch firstOrderTicket.rank[i] {
            case 0:
                str1 = ""
            case 1,2,3,4,5,6,7,8:
                str1 = String(str1.prefix(firstOrderTicket.rank[i]))
                str2 = String(str2.prefix(8 - firstOrderTicket.rank[i]))
            default:
                str2 = ""
            }
            checkScreen.result[13 + i] = str1 + str2
        }
        checkScreen.result[20] = checkScreen.result[20].replacingOccurrences(of: "o", with: "•")
        checkScreen.result[21] = checkScreen.result[21].replacingOccurrences(of: "o", with: "•")
        checkScreen.result[22] = separateComma(num: firstOrderTicket.prize)
        checkScreen.result[23] = String(firstOrderTicket.winner)
        checkScreen.result[24] = separateComma(num: firstOrderTicket.difficulty)
        checkScreen.result[25] =  String(firstOrderTicket.major) + "-" + String(firstOrderTicket.minor) + "-" + String(firstOrderTicket.draw)
        checkScreen.result[26] = "-"
    }
  
    func checkScreenSort() {
        //  MARK:指定されたソート順位で連番を振る
        checkScreen.all.removeAll()
        
        for ticket in buyTickets {
            checkScreen.one[0] = "0"
            
            for match in 0...ticket.mark.count - 1  {
                checkScreen.one[match + 1] = String(ticket.mark[match])
            }
            for j in 0...ticket.rank.count - 1 {
                var str1 = "oooooooo"
                var str2 = "________"
                switch ticket.rank[j] {
                case 0:
                    str1 = ""
                case 1,2,3,4,5,6,7,8:
                    str1 = String(str1.prefix(ticket.rank[j]))
                    str2 = String(str2.prefix(8 - ticket.rank[j]))
                default:
                    str2 = ""
                }
                checkScreen.one[j + 14] = str1 + str2
            }
            checkScreen.one[21] = checkScreen.one[21].replacingOccurrences(of: "o", with: "•")
            checkScreen.one[22] = checkScreen.one[22].replacingOccurrences(of: "o", with: "•")
            checkScreen.one[23] = String(ticket.prize)
            checkScreen.one[24] = String(ticket.winner)
            checkScreen.one[25] = String(ticket.difficulty)
            checkScreen.one[26] = String(ticket.major) + "-" + String(ticket.minor) + "-" + String(ticket.draw)
            checkScreen.one[27] = String(ticket.hit)
            if checkScreen.sort == cc.mainStream{
                checkScreen.one[27] = String(ticket.mainstream)
            }
            checkScreen.all.append(checkScreen.one)
        }
        
        if checkScreen.sort == cc.mainStream {
            checkScreen.all.sort { Int($0[27])! > Int($1[27])! }  // ◎の数
        }else if  checkScreen.sort == cc.hit{
            checkScreen.all.sort { Int($0[27])! > Int($1[27])! }  // あたりの数
        }else if  checkScreen.sort == cc.difficulty{
            checkScreen.all.sort { Int($0[25])! > Int($1[25])! }  // 確率
        }
        var sortNo = 0
        for i in 0...buyTickets.count - 1 {
            sortNo += 1
            checkScreen.all[i][0] = String(sortNo)
        }
    }
    
    func limit10Pieces()  {
        //  MARK:ページ数と連番から表示する１０件分を特定
        for i in 0...cc.displayRowSize {
            for j in 0...cc.displayColumnSize - 1 {
                checkScreen.display[i][j] = " "
            }
        }
        for sortNo in 0...buyTickets.count - 1 {
            if ((Int(checkScreen.all[sortNo][0])! > (checkScreen.pageNo - 1 ) * cc.displayColumnSize) &&
                (Int(checkScreen.all[sortNo][0])! <= checkScreen.pageNo * cc.displayColumnSize)){
                for i in 0...buyTicket.mark.count - 1 {
                    checkScreen.display[i][(Int(checkScreen.all[sortNo][0])! - 1) % 10] = checkScreen.all[sortNo][i + 1]
                }
                for i in 0...buyTicket.rank.count - 1 {
                    checkScreen.display[i + 13][(Int(checkScreen.all[sortNo][0])! - 1) % 10] = checkScreen.all[sortNo][i + 14]
                }
                checkScreen.display[22][(Int(checkScreen.all[sortNo][0])! - 1) % 10] = checkScreen.all[sortNo][23]   //  当選金
                checkScreen.display[23][(Int(checkScreen.all[sortNo][0])! - 1) % 10] = checkScreen.all[sortNo][24]   //  当選口数
                checkScreen.display[24][(Int(checkScreen.all[sortNo][0])! - 1) % 10] = checkScreen.all[sortNo][25]   //  当選確率
                checkScreen.display[25][(Int(checkScreen.all[sortNo][0])! - 1) % 10] = checkScreen.all[sortNo][26]   //  本命対抗
                checkScreen.display[26][(Int(checkScreen.all[sortNo][0])! - 1) % 10] = checkScreen.all[sortNo][27]   //  本線◎数
                //  当選金
                let prize = Int(checkScreen.display[22][(Int(checkScreen.all[sortNo][0])! - 1) % cc.displayColumnSize])
                let separateCommaPrize = separateComma(num: prize!)
                checkScreen.display[22][(Int(checkScreen.all[sortNo][0])! - 1) % cc.displayColumnSize] = separateCommaPrize
                
                //  当選確率
                let difficulty = Int(checkScreen.display[24][(Int(checkScreen.all[sortNo][0])! - 1) % cc.displayColumnSize])
                let separateCommaDifficulty = separateComma(num: difficulty!)
                checkScreen.display[24][(Int(checkScreen.all[sortNo][0])! - 1) % cc.displayColumnSize] = separateCommaDifficulty
            }
        }
    }
    
    func displayCheckScreen(){
        //  MARK:表示切り替え
        if (checkScreen.choisu == cc.rezult ){
            for match in 0...buyTicket.mark.count - 1 {
                for j in 0...cc.displayColumnSize - 1 {
                    
                    if homeScreen.matchResult != Array<Int>(repeating: 0,count:13){
                        
                        if (checkScreen.display[match][j] == "1") {
                            if homeScreen.matchResult[match] == 1{
                                checkScreen.display[match][j] = "◯"
                            }else{
                                checkScreen.display[match][j] = "×"
                            }
                        }
                        if(checkScreen.display[match][j] == "0"){
                            if homeScreen.matchResult[match] == 0{
                                checkScreen.display[match][j] = "◯"
                            }else{
                                checkScreen.display[match][j] = "×"
                            }
                        }
                        if(checkScreen.display[match][j] == "2"){
                            if homeScreen.matchResult[match] == 2{
                                checkScreen.display[match][j] = "◯"
                            }else{
                                checkScreen.display[match][j] = "×"
                            }
                        }
                    }else{
                        if (checkScreen.display[match][j] == "1") {
                            checkScreen.display[match][j] = managment.rateDisp[match][cm.home]
                        }
                        if(checkScreen.display[match][j] == "0"){
                            checkScreen.display[match][j] = managment.rateDisp[match][cm.draw]
                        }
                        if(checkScreen.display[match][j] == "2"){
                            checkScreen.display[match][j] = managment.rateDisp[match][cm.away]
                        }
                    }
                    
                }
            }
        }
        
        if homeScreen.matchResult != Array<Int>(repeating: 0,count:13){
            if (checkScreen.choisu == cc.team){
                for match in 0...homeScreen.matchResult.count - 1 {
                    if homeScreen.matchResult[match] == 1 {
                        checkScreen.result[match] = managment.match[match][cm.homeTeam]
                    }
                    if homeScreen.matchResult[match] == 0 {
                        checkScreen.result[match] = "引分け"
                    }
                    if homeScreen.matchResult[match] == 2 {
                        checkScreen.result[match] = managment.match[match][cm.awayTeam]
                    }
                }
            }else{
                for match in 0...homeScreen.matchResult.count - 1 {
                    checkScreen.result[match] = String(homeScreen.matchResult[match])
                }
            }
        }

        if (checkScreen.choisu == cc.team){
            for match in 0...buyTicket.mark.count - 1 {
                for j in 0...cc.displayColumnSize - 1 {
                    if (checkScreen.display[match][j] == "1") {
                        checkScreen.display[match][j] = managment.match[match][cm.homeTeam]
                    }
                    if(checkScreen.display[match][j] == "0"){
                        checkScreen.display[match][j] = "引分け"
                    }
                    if(checkScreen.display[match][j] == "2"){
                        checkScreen.display[match][j] = managment.match[match][cm.awayTeam]
                    }
                }
            }
        }
    }
    
    func checkupHit() {
        temporaryTickets.removeAll()
        for ticket in buyTickets {
            temporaryTicket = ticket
            temporaryTicket.hit = 0
            for match in 0...managment.match.count - 1{
                if temporaryTicket.mark[match] == homeScreen.matchResult[match] {
                    temporaryTicket.hit += 1
                }
            }
            temporaryTickets.append(temporaryTicket)
        }
        buyTickets = temporaryTickets
        temporaryTickets.removeAll()
    }
}
