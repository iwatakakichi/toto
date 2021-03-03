//
//  CsvReadWrite.swift
//  totoVer1.0.1
//
//  Created by 岩田嘉吉 on 2017/05/19.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//


import Cocoa

func teamNameUpload () -> Bool {
    //  MARK:チーム名称読み取り
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SSS"
    //  let now = Date()
    // print("\(now) start ticketsUpload 関数")
    
    let initialValue = "横浜Ｃ,横浜FC,愛媛,愛媛FC,広島,サンフレッチェ広島,大分,大分トリニータ,沼津,アスルクラロ沼津,Ｆ東京,FC東京,岡山,ファジアーノ岡山,川崎,川崎フロンターレ,山口,レノファ山口FC,札幌,北海道コンサドーレ札幌,福岡,アビスパ福岡,鳥取,ガイナーレ鳥取,Ｃ大阪,セレッソ大阪,東京Ｖ,東京ヴェルディ,福島,福島ユナイテッドFC,仙台,ベガルタ仙台,熊本,ロアッソ熊本,鹿児島,鹿児島ユナイテッドFC,清水,清水エスパルス,秋田,ブラウブリッツ秋田,神戸,ヴィッセル神戸,町田,FC町田ゼルビア,琉球,FC琉球,磐田,ジュビロ磐田,金沢,ツエーゲン金沢,湘南,湘南ベルマーレ,松本,松本山雅FC,群馬,ザスパクサツ群馬,柏,柏レイソル,水戸,水戸ホーリーホック,相模原,SC相模原,長崎,V・ファーレン長崎,栃木,栃木SC,長野,AC長野パルセイロ,横浜Ｍ,横浜F・マリノス,大宮,大宮アルディージャ,盛岡,グルージャ盛岡,浦和,浦和レッズ,新潟,アルビレックス新潟,藤枝,藤枝MYFC,鹿島,鹿島アントラーズ,山形,モンテディオ山形,北九州,ギラヴァンツ北九州,Ｇ大阪,ガンバ大阪,甲府,ヴァンフォーレ甲府,富山,カターレ富山,鳥栖,サガン鳥栖,徳島,徳島ヴォルティス,57,FC東京U－23,名古屋,名古屋グランパス,千葉,ジェフユナイテッド千葉,岐阜,FC岐阜,讃岐,カマタマーレ讃岐,京都,京都サンガF.C.,Ｙ横浜,Y.S.C.C.横浜,43,セレッソ大阪U－23,49,ガンバ大阪U－23"
    
    let textFileName = "teamName.csv"
    let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    let targetTextFilePath = documentDirectoryFileURL?.appendingPathComponent(textFileName)
    //  print("\(now) ticketsUpload 関数　読み込むファイルのパス: \(String(describing: targetTextFilePath))")
    
    do {
        let text = try String(contentsOf: targetTextFilePath!, encoding: String.Encoding.utf8)
        let CsvString = text.components(separatedBy: ",")
        sportsNavi.shortName.removeAll()
        for i in 0...sn.registrationTeam - 1{
            sportsNavi.shortName.updateValue(CsvString[i * 2 + 1], forKey: CsvString[i * 2])
            //  print("\(i) \t  key  \(CsvString[i * 2])  \t data  \(CsvString[i * 2 + 1])")
        }
        return true
    } catch let error as NSError {
        let CsvString = initialValue.components(separatedBy: ",")
        sportsNavi.shortName.removeAll()
        for i in 0...sn.registrationTeam - 1{
            sportsNavi.shortName.updateValue(CsvString[i * 2 + 1], forKey: CsvString[i * 2])
        }
        print("teamName.csv failed to read: \(error)")
        do {
            try initialValue.write(to: targetTextFilePath!, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("teamName.csv failed to write: \(error)")
            return false
        }
        return false
    }

}

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

func totoOnedelete () -> Bool {
    //  MARK:totoONEグランプリみんなの予想削除
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SSS"
    let now = Date()
    //  print("\(now) start totoOnedelete 関数")
    
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let filePath = docDir + "/" + "my toto.html"
    // print("\(now) totoPSdelete 関数　削除するファイルのパス: \(String(describing: filePath))")
    do {
        try FileManager.default.removeItem(atPath: filePath)
        print("\(now) totoOne delete: filePath=\(filePath)")
    } catch {
        print("\(now) totoOne failed!! to delete: filePath=\(filePath)")
        return false
    }
    
    return true
}

func totoPSdelete (totoPs:Int) -> Bool {
    //  MARK:totoPs削除
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss.SSS"
    let now = Date()
    //  print("\(now) start totoPSdelete 関数")
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let filePath = docDir + "/" + "X-" + String(totoPs) + ".csv"
    // print("\(now) totoPSdelete 関数　削除するファイルのパス: \(String(describing: filePath))")
    do {
        try FileManager.default.removeItem(atPath: filePath)
        print("\(now) totoPS delete: filePath=\(filePath)")
    } catch {
        print("\(now) totoPS failed!! to delete: filePath=\(filePath)")
        return false
    }
    
    return true
}
