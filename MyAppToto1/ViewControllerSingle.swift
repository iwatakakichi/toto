//
//  ViewControllerSingle.swift
//  totoVer1.0.1
//
//  Created by 岩田嘉吉 on 2017/05/19.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//

import Cocoa

class ViewControllerSingle: NSViewController, NSTableViewDataSource  {
  
    @IBOutlet weak var teamView: NSTableView!
    @IBOutlet weak var mainView: NSTableView!
    @IBOutlet weak var stampLabel: NSTextField!
    @IBOutlet weak var pageNoLable: NSTextField!
    @IBOutlet weak var ticketCountLable: NSTextField!
    @IBOutlet weak var markButton: NSButton!
    @IBOutlet weak var sortButton: NSButton!
    @IBOutlet weak var pageSelectButton: NSButton!
    @IBOutlet weak var selectionMatrix: NSMatrix!
    @IBOutlet weak var allSelectButton: NSButton!
    @IBOutlet weak var saleLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        singleScreen.initialize()
        saleLabel.stringValue = "第" + String(homeScreen.user[ch.sale]) + "回"
        singleScreen.stamp += 1
        checkScreen.stamp += 1
        stampLabel.intValue = Int32(singleScreen.stamp)
        if multSCreen.mark[ms.afterCompression] > 0{
            ticketCountLable.intValue = Int32(firstOrderTickets.count)
            singleScreen.pageNo = 1
            pageNoLable.intValue = Int32(singleScreen.pageNo)
            var _ = singleScreenSort()
            var _ = limit10Pieces()
            var _ = setCheckMark()
            var _ = displaySingleScreen()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView.tag == 0 {
            return managment.match.count
        }
        if tableView.tag == 1 {
            return singleScreen.display.count
        }
        if tableView.tag == 2 {
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
                if(tcol.identifier.rawValue == "Ticket0") {
                    return singleScreen.display[row][0]
                }else if(tcol.identifier.rawValue == "Ticket1") {
                    return singleScreen.display[row][1]
                }else if(tcol.identifier.rawValue == "Ticket2") {
                    return singleScreen.display[row][2]
                }else if(tcol.identifier.rawValue == "Ticket3") {
                    return singleScreen.display[row][3]
                }else if(tcol.identifier.rawValue == "Ticket4") {
                    return singleScreen.display[row][4]
                }else if(tcol.identifier.rawValue == "Ticket5") {
                    return singleScreen.display[row][5]
                }else if(tcol.identifier.rawValue == "Ticket6") {
                    return singleScreen.display[row][6]
                }else if(tcol.identifier.rawValue == "Ticket7") {
                    return singleScreen.display[row][7]
                }else if(tcol.identifier.rawValue == "Ticket8") {
                    return singleScreen.display[row][8]
                }else if(tcol.identifier.rawValue == "Ticket9") {
                    return singleScreen.display[row][9]
                }
            }
        }
        
        if tableView.tag == 2{
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
    
    @IBAction func pageSelect(_ sender: Any) {
        //  MARK:１ページ分を選択
        guard stampLabel.intValue == Int32(singleScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        checkScreen.stamp += 1
        if pageNoLable.stringValue != "ぺージ"{
            let remainder = firstOrderTickets.count % 10
            var maximum: Int = 0
            if singleScreen.pageNo * cs.displayColumnSize <= firstOrderTickets.count {
                maximum = cs.displayColumnSize - 1
            }else{
                maximum = remainder - 1
            }
        
            for displayColumn in 0...maximum{
                if singleScreen.noneDisplay[cs.noneDisplayLastOrder][displayColumn] == cs.outOfSelection{
                    var _ = addBuyTicket(tag: displayColumn)
                }
            }
            pageSelectButton.title = "選択"
            var _ = ticketsDownload ()
            var _ = singleScreenSort()
            var _ = limit10Pieces()
            var _ = displaySingleScreen()
            var _ = setCheckMark()
            mainView.reloadData()
        }
    }
    
    @IBAction func allSelect(_ sender: Any) {
        //  MARK:全件を選択
        guard stampLabel.intValue == Int32(singleScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        checkScreen.stamp += 1
        temporaryTickets.removeAll()
        for ticket in firstOrderTickets {
            temporaryTicket = ticket
            temporaryTicket.lastOrder = cs.choosing
            temporaryTickets.append(temporaryTicket)
        }
        firstOrderTickets = temporaryTickets
        temporaryTickets.removeAll()
        buyTickets.removeAll()
        for ticket in firstOrderTickets {
            temporaryTicket = ticket
            temporaryTicket.lastOrder = cs.choosing
            buyTickets.append(ticket)
        }
        temporaryTickets.removeAll()
        var _ = ticketsDownload ()
        var _ = singleScreenSort()
        var _ = limit10Pieces()
        var _ = displaySingleScreen()
        var _ = setCheckMark()
        mainView.reloadData()
        allSelectButton.title = "全部選択"
    }
    @IBAction func singleSelaction(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        //let row = matrix.selectedRow
        let colum = matrix.selectedColumn
        
        checkScreen.stamp += 1
        if pageNoLable.stringValue != "ぺージ"{
            let farstorderKey = singleScreen.noneDisplay[cs.noneDisplayfirstOrder][colum ]
            for ticket in firstOrderTickets{
                if  ticket.firstOrder == farstorderKey{
                    if ticket.lastOrder == cs.outOfSelection{
                        let _ = addBuyTicket(tag: colum)
                    }else if ticket.lastOrder == cs.choosing{
                        let _ = cancelBuyTicket(farstorderKey:farstorderKey)
                    }
                }
            }
            var _ = ticketsDownload ()
            var _ = singleScreenSort()
            var _ = limit10Pieces()
            var _ = displaySingleScreen()
            var _ = setCheckMark()
            mainView.reloadData()
        }
    }
    
    @IBAction func start(_ sender: Any) {
        // MARK:最初のページへ
        guard stampLabel.intValue == Int32(singleScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if pageNoLable.stringValue != "ぺージ"{
            singleScreen.pageNo = 1
            pageNoLable.intValue = Int32(singleScreen.pageNo)
            pageSelectButton.title = "ページ"
            var _ = singleScreenSort()
            var _ = limit10Pieces()
            var _ = displaySingleScreen()
            var _ = setCheckMark()
            mainView.reloadData()
        }
    }
    
    @IBAction func before(_ sender: Any) {
        // MARK:１つ前のページへ
        guard stampLabel.intValue == Int32(singleScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if pageNoLable.stringValue != "ぺージ"{
            if singleScreen.pageNo > 1 {
                singleScreen.pageNo -= 1
                pageNoLable.intValue = Int32(singleScreen.pageNo)
                pageSelectButton.title = "ページ"
                var _ = singleScreenSort()
                var _ = limit10Pieces()
                var _ = displaySingleScreen()
                var _ = setCheckMark()
                mainView.reloadData()
            }
        }
    }
    
    @IBAction func next(_ sender: Any) {
        // MARK:次のページへ
        guard stampLabel.intValue == Int32(singleScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if pageNoLable.stringValue != "ぺージ"{
            if firstOrderTickets.count > singleScreen.pageNo * cs.displayColumnSize {
                singleScreen.pageNo += 1
                pageNoLable.intValue = Int32(singleScreen.pageNo)
                pageSelectButton.title = "ページ"
                var _ = singleScreenSort()
                var _ = limit10Pieces()
                var _ = displaySingleScreen()
                var _ = setCheckMark()
                mainView.reloadData()
            }
        }
    }
   
    @IBAction func last(_ sender: Any) {
        // MARK:最後のページへ
        guard stampLabel.intValue == Int32(singleScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if pageNoLable.stringValue != "ぺージ"{
        if firstOrderTickets.count > 0 {
                singleScreen.pageNo = Int((firstOrderTickets.count - 1) / cs.displayColumnSize) + 1
                pageNoLable.intValue = Int32(singleScreen.pageNo)
                pageSelectButton.title = "ページ"
                var _ = singleScreenSort()
                var _ = limit10Pieces()
                var _ = displaySingleScreen()
                var _ = setCheckMark()
                mainView.reloadData()
            }
        }
    }
    
    @IBAction func mark(_ sender: Any) {
        //  MARK:表示切り替え
        guard stampLabel.intValue == Int32(singleScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if pageNoLable.stringValue != "ぺージ"{
            if (singleScreen.choisu == cs.mark){
                singleScreen.choisu = cs.team
                markButton.title  = "チーム"
            }else if(singleScreen.choisu == cs.team){
                singleScreen.choisu = cs.rate
                markButton.title  = "投票率"
            }else if(singleScreen.choisu == cs.rate){
                singleScreen.choisu = cs.mark
                markButton.title  = "マーク"
            }
            var _ = limit10Pieces()
            var _ = displaySingleScreen()
            mainView.reloadData()
        }
    }
    
    @IBAction func sort(_ sender: Any) {
        //  MARK:ソート
        guard stampLabel.intValue == Int32(singleScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        if pageNoLable.stringValue != "ぺージ"{
            if (singleScreen.sort == cs.prize){
                sortButton.title  = "◎印の順"
                singleScreen.sort = cs.mainstream
            }else if(singleScreen.sort == cs.mainstream){
                sortButton.title  = "当選金順"
                singleScreen.sort = cs.prize
            }
            var _ = singleScreenSort()
            var _ = limit10Pieces()
            var _ = displaySingleScreen()
            var _ = setCheckMark()
            mainView.reloadData()
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        //  MARK:リセット
        guard stampLabel.intValue == Int32(singleScreen.stamp) else {
            print("Scrapped screen")
            return
        }
        checkScreen.stamp += 1
        temporaryTickets.removeAll()
        for ticket in firstOrderTickets {
            temporaryTicket = ticket
            temporaryTicket.lastOrder = cs.outOfSelection
            temporaryTickets.append(temporaryTicket)
        }
        firstOrderTickets = temporaryTickets
        temporaryTickets.removeAll()
        pageSelectButton.title = "ページ"
        allSelectButton.title = "すべて"
        buyTickets.removeAll()
        var _ = ticketsDownload ()
        var _ = singleScreenSort()
        var _ = limit10Pieces()
        var _ = displaySingleScreen()
        var _ = setCheckMark()
            mainView.reloadData()
    }

    //  MARK:指定されたソート順位で連番を振る
    func singleScreenSort() {
        singleScreen.all.removeAll()
        
        for ticket in firstOrderTickets {
            singleScreen.one[0] = "0"     //  sort 用
            for match in 0...ticket.mark.count - 1  {
                singleScreen.one[match + 1] = String(ticket.mark[match])
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
                singleScreen.one[j + 14] = str1 + str2
            }
            singleScreen.one[21] = singleScreen.one[21].replacingOccurrences(of: "o", with: "•")
            singleScreen.one[22] = singleScreen.one[22].replacingOccurrences(of: "o", with: "•")
            singleScreen.one[23] = String(ticket.prize)
            singleScreen.one[24] = String(ticket.winner)
            singleScreen.one[25] = String(ticket.difficulty)
            singleScreen.one[26] = String(ticket.major) + "-" + String(ticket.minor) + "-" + String(ticket.draw)
            singleScreen.one[27] = String(ticket.mainstream)
            singleScreen.one[28] = String(ticket.firstOrder)
            singleScreen.one[29] = String(ticket.lastOrder)
            singleScreen.all.append(singleScreen.one)
        }
        if  singleScreen.sort == cs.prize{
            singleScreen.all.sort { Int($0[25])! > Int($1[25])! }
        }else if singleScreen.sort == cs.mainstream {
            singleScreen.all.sort { Int($0[25])! < Int($1[25])! }
            singleScreen.all.sort { Int($0[27])! > Int($1[27])! }
        }
        var sortNo = 0
        for i in 0...firstOrderTickets.count - 1 {
            sortNo += 1
            singleScreen.all[i][0] = String(sortNo)
        }
    }
    //  MARK:ページ数と連番から表示する１０件分を特定 
    func limit10Pieces()  {
        singleScreen.display = [[String]](repeating: [String](repeating: "", count: 10),count: 27)
        singleScreen.noneDisplay = [[Int]](repeating: [Int](repeating: 0, count: 10),count: 2)
        
        for sortNo in 0...firstOrderTickets.count - 1 {
            if ((Int(singleScreen.all[sortNo][0])! > (singleScreen.pageNo - 1 ) * cs.displayColumnSize) &&
                (Int(singleScreen.all[sortNo][0])! <= singleScreen.pageNo * cs.displayColumnSize)){
                for i in 0...firstOrderTicket.mark.count - 1 {
                    singleScreen.display[i][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize] = singleScreen.all[sortNo][i + 1]
                }
                for i in 0...firstOrderTicket.rank.count - 1 {
                    singleScreen.display[i + 13][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize] = singleScreen.all[sortNo][i + 14]
                }
                singleScreen.display[22][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize] = singleScreen.all[sortNo][23]   //  当選金
                singleScreen.display[23][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize] = singleScreen.all[sortNo][24]   //  当選口数
                singleScreen.display[24][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize] = singleScreen.all[sortNo][25]   //  当選確率
                singleScreen.display[25][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize] = singleScreen.all[sortNo][26]   //  本命対抗
                singleScreen.display[26][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize] = singleScreen.all[sortNo][27]   //  本線◎数
                singleScreen.noneDisplay[0][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize] = Int(singleScreen.all[sortNo][28])! //  farstOrder
                singleScreen.noneDisplay[1][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize] = Int(singleScreen.all[sortNo][29])! //  lastOrder
                //  当選金
                let prize = Int(singleScreen.display[22][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize])
                let separateCommaPrize = separateComma(num: prize!)
                singleScreen.display[22][(Int(singleScreen.all[sortNo][0])! - 1) % 10] = separateCommaPrize
                
                //  当選確率
                let difficulty = Int(singleScreen.display[24][(Int(singleScreen.all[sortNo][0])! - 1) % cs.displayColumnSize])
                let separateCommaDifficulty = separateComma(num: difficulty!)
                singleScreen.display[24][(Int(singleScreen.all[sortNo][0])! - 1) % 10] = separateCommaDifficulty
            }
        }
    }
    //  MARK:表示切り替え
    func displaySingleScreen(){
        if (singleScreen.choisu == 1){
            for match in 0...firstOrderTicket.mark.count - 1  {
                for j in 0...cs.displayColumnSize - 1{
                    if (singleScreen.display[match][j] == "1") {
                        singleScreen.display[match][j] = managment.match[match][1]
                    }
                    if(singleScreen.display[match][j] == "0"){
                        singleScreen.display[match][j] = "引分け"
                    }
                    if(singleScreen.display[match][j] == "2"){
                        singleScreen.display[match][j] = managment.match[match][2]
                    }
                }
            }
        }
        
        if (singleScreen.choisu == 2){
            for match in 0...firstOrderTicket.mark.count - 1  {
                for j in 0...cs.displayColumnSize - 1{
                    if (singleScreen.display[match][j] == "1") {
                        singleScreen.display[match][j] = managment.rateDisp[match][0]
                    }
                    if(singleScreen.display[match][j] == "0"){
                        singleScreen.display[match][j] = managment.rateDisp[match][1]
                    }
                    if(singleScreen.display[match][j] == "2"){
                        singleScreen.display[match][j] = managment.rateDisp[match][2]
                    }
                }
            }
        }
    }
    
    func addBuyTicket(tag: Int) {
        let farstorderKey = singleScreen.noneDisplay[cs.noneDisplayfirstOrder][tag]
        temporaryTickets.removeAll()
        for ticket in firstOrderTickets {
            temporaryTicket = ticket
            if temporaryTicket.firstOrder == farstorderKey{
                temporaryTicket.lastOrder = cs.choosing
                buyTickets.append(temporaryTicket)
            }
            temporaryTickets.append(temporaryTicket)
        }
        firstOrderTickets = temporaryTickets
        temporaryTickets.removeAll()
    }
    
    func cancelBuyTicket(farstorderKey:Int) {
        temporaryTickets.removeAll()
        for ticket in firstOrderTickets {
            temporaryTicket = ticket
            if temporaryTicket.firstOrder == farstorderKey{
                temporaryTicket.lastOrder = cs.outOfSelection
            }
            temporaryTickets.append(temporaryTicket)
        }
        firstOrderTickets = temporaryTickets
        temporaryTickets.removeAll()
        for ticket in buyTickets {
            if ticket.firstOrder != farstorderKey{
                temporaryTickets.append(ticket)
            }
        }
        buyTickets = temporaryTickets
        temporaryTickets.removeAll()
    }
    //  MARK:チェック印"✔︎"表示する。
    func setCheckMark() {
        for cell in 0...9 {
            selectionMatrix.cells[cell].title = ""
            if singleScreen.noneDisplay[cs.noneDisplayLastOrder][cell] == cs.choosing{
            selectionMatrix.cells[cell].title  = "✔︎"
            }
        }
    }

}
