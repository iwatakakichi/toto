//
//  CsvReadWrite.swift
//  totoVer1.0.1
//
//  Created by 岩田嘉吉 on 2017/05/19.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//


import Cocoa

func ticketsUpload () -> Bool {
    //  MARK:購入チッケット読み取り
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SSS"
    //  let now = Date()
    // print("\(now) start ticketsUpload 関数")
    
    let textFileName = "ticket.csv"
    let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    let targetTextFilePath = documentDirectoryFileURL?.appendingPathComponent(textFileName)
    //  print("\(now) ticketsUpload 関数　読み込むファイルのパス: \(String(describing: targetTextFilePath))")
     buyTickets.removeAll()
    do {
        let text = try String(contentsOf: targetTextFilePath!, encoding: String.Encoding.utf8)
        let CsvString = text.components(separatedBy: ",")
        homeScreen.user[ch.sale] = Int(CsvString[0])!
     //   checkScreen.buyCount = Int(CsvString[1])!
        buyTickets.removeAll()
        let cc = Int(CsvString[1])!
        if cc > 0{
            for i in 0...cc - 1 {
                for j in 0...buyTicket.mark.count - 1 {
                    buyTicket.mark[j] = Int(CsvString[i * 33 + 2 + j])!
                }
                for j in 0...buyTicket.rank.count - 1 {
                    buyTicket.rank[j] = Int(CsvString[i * 33 + 15 + j])!
                }
            
                buyTicket.prize = Int(CsvString[i * 33 + 24])!
                buyTicket.winner = Int(CsvString[i * 33 + 25])!
                buyTicket.difficulty = Int(CsvString[i * 33 + 26])!
                buyTicket.major = Int(CsvString[i * 33 + 27])!
                buyTicket.minor = Int(CsvString[i * 33 + 28])!
                buyTicket.draw = Int(CsvString[i * 33 + 29])!
                buyTicket.mainstream = Int(CsvString[i * 33 + 30])!
                buyTicket.hit = Int(CsvString[i * 33 + 31])!
                buyTicket.firstOrder = Int(CsvString[i * 33 + 32])!
                buyTicket.lastOrder = Int(CsvString[i * 33 + 33])!
                buyTicket.buyer = CsvString[i * 33 + 34]
  
                buyTickets.append(buyTicket)
            }
        }
        return true
    } catch let error as NSError {
        print("failed to read: \(error)")
        return false
    }
}

func ticketsDownload () -> Bool {
    //  MARK:購入チッケット保存
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SSS"
    //  let now = Date()
    //  print("\(now) start ticketsDownload 関数")
    
    let textFileName = "ticket.csv"
    let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    let targetTextFilePath = documentDirectoryFileURL?.appendingPathComponent(textFileName)
    
    var Text : String = String(homeScreen.user[ch.sale]) + ","
    Text = Text + String(buyTickets.count) +  ","
    
    for buyTicket in buyTickets {
        for j in 0...buyTicket.mark.count - 1 {
            Text = Text + String(buyTicket.mark[j])  + ","
        }
        for j in 0...buyTicket.rank.count - 1 {
            Text = Text + String(buyTicket.rank[j])  + ","
        }
  
        Text = Text + String(buyTicket.prize)  + ","
        Text = Text + String(buyTicket.winner)  + ","
        Text = Text + String(buyTicket.difficulty) + ","
        Text = Text + String(buyTicket.major) + ","
        Text = Text + String(buyTicket.minor) + ","
        Text = Text + String(buyTicket.draw) + ","
        Text = Text + String(buyTicket.mainstream) + ","
        Text = Text + String(buyTicket.hit) + ","
        Text = Text + String(buyTicket.firstOrder) + ","
        Text = Text + String(buyTicket.lastOrder) + ","
        Text = Text + buyTicket.buyer  + ","

    }
    
    // 末尾文字から一文字分戻って、最後の\nを取り除く
    //let index = Text.index(before: Text.endIndex)
    // let initialText = Text.substring(to: index)
    let initialText = String(Text.prefix(Text.count - 1))
    
    do {
        try initialText.write(to: targetTextFilePath!, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print("ticketsDownload failed to write: \(error)")
        return false
    }
    return true
}

func ticketsDelete () -> Bool {
    //  MARK:購入チッケット削除
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SSS"
    let now = Date()
    //  print("\(now) start ticketsUpload 関数")

    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let filePath = docDir + "/ticket.csv"
    //  print("\(now) ticketsDelete 関数　削除するファイルのパス: \(String(describing: filePath))")
    // 削除処理
    do {
        try FileManager.default.removeItem(atPath: filePath)
        print("\(now) ticketsDelete: filePath=\(filePath)")
    } catch {
        print("\(now) tickets failed!! to delete: filePath=\(filePath)")
        return false
    }
    
    return true
}

