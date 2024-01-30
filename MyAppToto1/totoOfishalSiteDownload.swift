//
//  totoOfishalSiteDownload.swift
//  totoVer1.0.1
//
//  Created by 岩田嘉吉 on 2017/05/19.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//

import Cocoa

func totoOfficialSiteDownLoad(sale:String) ->Bool {
    //  MARK:トトオフィシャルサイトから投票数をダンロード
    //  let formatter = DateFormatter()
    //  ormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
    //  let now = Date()
    //  print("\(now) start totoOfishalSiteDownLoad関数")
    let url = URL(string:"https://store.toto-dream.com/dcs/subos/screen/pi09/spin003/PGSPIN00301InitVoteRate.form?popup=disp&commodityId=01&holdCntId=" + String(format: "%04d",homeScreen.user[ch.sale]))!
    //let url = URL(string:"http://www.toto-dream.com/dci/I/IPC/IPC01.do?op=initVoteRate&commodityId=01&holdCntId=" +  String(format: "%04d",homeScreen.user[ch.sale]))!
    let ss = HttpClientImpl()
    let t = ss.execute(request: URLRequest(url: url))
    if t.2 != nil{
        print("totoOfficialSiteDownLoad HttpClientImpl() t.2 error")
        return false
    }
    
    let getData: NSString = NSString(data: t.0! as Data, encoding: String.Encoding.utf8.rawValue)!
    let myStr = getData as String
    let CString = myStr.replacingOccurrences(of: "C", with: "C")    //  漢字のCを英大文字のCへ
    var temporaryString = CString .replacingOccurrences(of: " ", with: "")
    var str = temporaryString.replacingOccurrences(of: ",", with: "")
    temporaryString = str.replacingOccurrences(of: "\r", with: "")
    str = temporaryString.replacingOccurrences(of: "\n", with: "")
    
    if str.contains("ご指定の投票状況は表示できません。"){
        homeScreen.sale = "ご指定の投票状況は表示できません。"
        print("totoOfficialSiteDownLoad contains　ご指定の投票状況は表示できません。")
        return false
    }else if str.contains("中止"){
        print("totoOfficialSiteDownLoad contains 中止試合あり")
        return false
    }else if str.contains("エラー"){
        print("totoOfficialSiteDownLoad contains エラー")
        return false
    }else{
        //  MARK:   word 切り出し--------------------------
        var cell = ""
        var cells = Array<String>()
        var stack = 0
        var beforeStr = ""
        var row = 0
        
        for c in str {
            if stack < 0{
                cell = cell + beforeStr
                stack -= 1
                
            }
            if (beforeStr == ">" && String(c) != "<"){
                stack -= 1  //  push
            }
            if (String(c) == "<" || String(c) == "（") || String(c) == "た" {
                if (cell != "" &&  cell != "<"){
                    //  print("row = \(row) cell - \(cell)")     //  totoオフィシャルサイトのレイアウトが変わったらここに戻っておいで
                    row += 1
                    cells.append(cell)
                    cell = ""
                    stack = 0  //  pop
                }
            }
            beforeStr = String(c)
        }
        
        //  MARK:   チーム、投票数をそれぞれの配列に格納 -----
        var Increment = 0
        var offset = 0      //  試合No.１のチーム名
        for i in 0...50 {
            if cells[i] == "1" {
                offset = i
            }
        }
        for i in 0...50 {
            if cells[i] == "2" {
                Increment = i - offset
            }
        }
        if offset == 0 || Increment == 0 {
            print("totoOfficialSiteDownLoad error 試合No.1 ＝ \(cells[offset]) offset \(offset) Increment \(Increment)")
        }
        
        for match in 0...managment.match.count - 1  {
            managment.match[match][0] = String(match + 1)
            var myPoint = offset + 1 + match * Increment
            managment.match[match][1] = (cells[myPoint])
            myPoint = offset + 2 + match * Increment
            managment.vote[match][0] = Int((cells[myPoint]))!
            myPoint = offset + 3 + match * Increment
            managment.vote[match][1] = Int((cells[myPoint]))!
            myPoint = offset + 4 + match * Increment
            managment.vote[match][2] = Int((cells[myPoint]))!
            myPoint = offset + 5 + match * Increment
            managment.match[match][2] = (cells[myPoint])
        }
        managment.calcRate()
        
        for i in 0...cells.count - 1 {
            if cells[i] == "販売期間" {
                homeScreen.sale = cells[i + 1]
                break
            }
        }
            
    }

    return true
}

func lotteryResultDownLoad(sale:Int) ->Bool {
    //  MARK:トトオフィシャルサイトから試合結果をダウンロード
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
    //  let now = Date()
    //  print("\(now) start LotteryResultDownLoad関数 \(Kaisaikai)")
    
    //let url = URL(string: "http://www.toto-dream.com/dci/I/IPB/IPB01.do?op=lnkHoldCntLotResultLsttoto&holdCntId=" +  String(format: "%04d",sale))!
    let url = URL(string: "https://store.toto-dream.com/dcs/subos/screen/pi04/spin011/PGSPIN01101LnkHoldCntLotResultLsttoto.form?holdCntId="  +  String(format: "%04d",sale))!
    let ss = HttpClientImpl()
    let t = ss.execute(request: URLRequest(url: url))
    let getData: NSString = NSString(data: t.0! as Data, encoding: String.Encoding.utf8.rawValue)!
    let myStr = getData as String
    
    if myStr.range(of:"ご指定のくじ結果は表示できません。") != nil{
        return false
    }else if myStr.range(of:"回 toto　くじ結果") == nil{
        return false
    }else if myStr.range(of:"中止") != nil{
        print("\(sale) 回　中止試合あり")
        return false
    }else{
       var _ = lotteryResult(text: myStr)
    }
        
    return true
}

func lotteryResult(text:String){
    //  MARK:トトオフィシャルサイトから試合結果をダウンロードしたデータを編集
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
    //  let now = Date()
    //  print("\(now) start LotteryResul関数")
    
    var temporaryString = text.replacingOccurrences(of: " ", with: "")
    var str = temporaryString.replacingOccurrences(of: ",", with: "")
    temporaryString = str.replacingOccurrences(of: "\r", with: "")
    str = temporaryString.replacingOccurrences(of: "\n", with: "")
    
    //  MARK:   word 切り出し--------------------------
    var cell = ""
    var cells = Array<String>()
    var stack = 0
    var beforeStr = ""
    var row = 0
    
    for c in str{
        if stack < 0 {
            cell = cell + beforeStr
            stack -= 1
        }
        if (beforeStr == ">" && String(c) != "<"){
            stack -= 1  //  push
        }
        if (String(c) == "<" || String(c) == "（") || String(c) == "た" {
            if (cell != "" &&  cell != "<"){
                //  print("row = \(row) cell - \(cell)")    //   totoオフィシャルサイトのレイアウトが変わったらここに戻っておいで
                row += 1
                cells.append(cell)
                cell = ""
                stack = 0  //  pop
            }
        }
        beforeStr = String(c)
    }
    
    //  MARK:  結果のセット--------------------------
    var offset = 0
    let zobun = 7
    var prize: String = ""
 
    for i in 0...cells.count - 1{
        if cells[i] == "開催日" && offset == 0{
            offset = i + 14
        }
    }

    if offset > 0 {
        for match in 0...homeScreen.matchResult.count - 1 {
            let myPoint = offset + match * zobun
            if isOnlyNumber(cells[myPoint]){
                homeScreen.matchResult[match] = Int(cells[myPoint])!
            }
        }
       
        prize = cells[offset + 92]
        
        if let range = prize.range(of: "円") {
            prize.removeSubrange(range)
        }
        if isOnlyNumber(prize){
            homeScreen.prize = Int(prize)!
        }

    }
}
