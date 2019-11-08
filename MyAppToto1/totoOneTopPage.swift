//
//  totoOneTopPage.swift
//  MyAppToto1
//
//  Created by 岩田嘉吉 on 2018/05/04.
//  Copyright © 2018年 岩田嘉吉. All rights reserved.
//

import Cocoa


struct totoOneTopPageControl {
    var star:[[String]] = [[String]](repeating: [String](repeating: "", count: 3),count: 13)
    var releasePeriod: Int = 0
    init(star:[[String]],releasePeriod:Int){
        self.star = star
        self.releasePeriod = releasePeriod
    }
}

var totoOneTopPage = totoOneTopPageControl(star:[[String]](repeating: [String](repeating: "", count: 3),count: 13),releasePeriod:0)


func totoOneTopPageDownload() -> Bool {
    
        
    let url = URL(string:"http://www.totoone.jp/blog/toto/")!   //  2018.5.8 変更
    let ss = HttpClientImpl()
    let t = ss.execute(request: URLRequest(url: url))
    if t.2 != nil{
        print("sportsNaviDownload HttpClientImpl() t.2 error")
        return false
    }
        
    let getData: NSString = NSString(data: t.0! as Data, encoding: String.Encoding.utf8.rawValue)!
    let myStr = getData as String
        
    var temporaryString = myStr.replacingOccurrences(of: " ", with: "")
    var str = temporaryString.replacingOccurrences(of: ",", with: "")
    temporaryString = str.replacingOccurrences(of: "\r", with: "")
    str = temporaryString.replacingOccurrences(of: "\n", with: "")
        
    //  MARK:   開催回チェック--------------------------
   
    var cell = ""
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
                if cell.contains("回開催販売期間"){
                    let prefixMoji = cell.prefix(5)
                    let suffixMoji = prefixMoji.suffix(4)
                    totoOneTopPage.releasePeriod = Int(suffixMoji)!
                    //  print(totoOneTopPage.releasePeriod)
                }
            
                cell = ""
                stack = 0  //  pop
            }
        }
        beforeStr = String(c)
    }
    
    //  MARK:   星取り 切り出し--------------------------
    var starString = ""
    for c in str {
        if c == "◯" || c == "△" || c == "●"{
            starString += String(c)
        }
    }
  
    if totoOneTopPage.releasePeriod == homeScreen.user[ch.sale] && totoOneTopPage.releasePeriod > 0 && starString.count == managment.match.count * 10 {
        for match in 0...managment.match.count - 1{
            var partString = starString[starString.index(starString.startIndex, offsetBy: match * 10)..<starString.index(starString.startIndex, offsetBy: match * 10 + 5)]
            totoOneTopPage.star[match][0] = String(partString)
            totoOneTopPage.star[match][1] = "VS"
            partString = starString[starString.index(starString.startIndex, offsetBy: match * 10 + 5)..<starString.index(starString.startIndex, offsetBy: match * 10 + 10)]
            totoOneTopPage.star[match][2] = String(partString)
        }
    }else{
        for match in 0...managment.match.count - 1{
            totoOneTopPage.star[match][0] = "*****"
            totoOneTopPage.star[match][1] = "VS"
            totoOneTopPage.star[match][2] = "*****"
        }
    }
    
    return true
}
