//
//  sportsNavi.swift
//  MyAppToto1
//
//  Created by 岩田嘉吉 on 2018/05/02.
//  Copyright © 2018年 岩田嘉吉. All rights reserved.
//


import Cocoa

struct sportsNaviControl {
    var shortName = [String:String] ()
    var rankTable:[[String]] = [[String]](repeating: [String](repeating: "", count: 10),count: 57)
    var rank:[[String]] = [[String]](repeating: [String](repeating: "", count: 3),count: 13)
    var winLoss:[[String]] = [[String]](repeating: [String](repeating: "", count: 3),count: 13)
    var score:[[String]] = [[String]](repeating: [String](repeating: "", count: 3),count: 13)
    var starTable:[[String]] = [[String]](repeating: [String](repeating: "", count: 3),count: 13)
    var registrationTeams: Array<Int> = Array<Int>(repeating: 0,count:3)    //  j1チーム数、j2チーム数、j3チーム数
    var display:Int = 0
    
    init(shortName:[String:String],rankTable:[[String]],rank:[[String]],winLoss:[[String]],score:[[String]],starTable:[[String]],registrationTeams:[Int],display:Int){
        self.shortName = shortName
        self.rankTable = rankTable
        self.winLoss = winLoss
        self.score = score
        self.starTable = starTable
        self.registrationTeams = registrationTeams
        self.display = display
    }
}

var sportsNavi = sportsNaviControl(shortName:[String:String] (),rankTable:[[String]](repeating: [String](repeating: "", count: 10),count: 57),rank:[[String]](repeating: [String](repeating: "", count: 3),count: 13),winLoss:[[String]](repeating: [String](repeating: "", count: 3),count: 13),score:[[String]](repeating: [String](repeating: "", count: 3),count: 13),starTable:[[String]](repeating: [String](repeating: "", count: 3),count: 13),registrationTeams: [18,22,17],display:0)

var basePoint = 113  // 仮置き、よくずれる
struct cn {
    static let vote = 0
    static let rank = 1
    static let winLoss = 2
    static let score = 3
    static let left = 0
    static let middle = 1
    static let right = 2
}
struct sn {
    static let rank = 0
    static let team = 1
    static let points = 2
    static let games = 3
    static let win = 4
    static let draw = 5
    static let defeat = 6
    static let gainPoint = 7
    static let lossPoint = 8
    static let goalScore = 9
    static let registrationTeam = 57    //  j1 18 j2 22 j3 17
}

func sportsNaviDownload() -> Bool {
    for jleague in 1...3{
        
        let url = URL(string:"https://soccer.yahoo.co.jp/jleague/standings/j" + String(jleague))!
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
      
        if str.contains("現在、データはありません。") {
            return false
        }
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
                    if cell == "得失点差"{
                        basePoint = row + 1 // 起点を得失点差の次の順位『１』に決めた
                    }
                    //  print("row = \(row) cell - \(cell)")     //  totoオフィシャルサイトのレイアウトが変わったらここに戻っておいで
                    row += 1
                    cells.append(cell)
                    cell = ""
                    stack = 0  //  pop
                }
            }
            beforeStr = String(c)
        }
        
        for registration in 0...sportsNavi.registrationTeams[jleague - 1] - 1{
            var offset = 0
            switch jleague {
                case 1: offset = 0
                case 2: offset = sportsNavi.registrationTeams[0]
                case 3:  offset = sportsNavi.registrationTeams[0] + sportsNavi.registrationTeams[1]
                default: print("error")
            }
            sportsNavi.rankTable[offset + registration][sn.rank] = "J" + String(jleague) + "   " + String(registration + 1)
            sportsNavi.rankTable[offset + registration][sn.team] = cells[registration * 10 + basePoint + 1]
            sportsNavi.rankTable[offset + registration][sn.points] = cells[registration * 10 + basePoint + 2]
            sportsNavi.rankTable[offset + registration][sn.games] = cells[registration * 10 + basePoint + 3]
            sportsNavi.rankTable[offset + registration][sn.win] = cells[registration * 10 + basePoint + 4]
            sportsNavi.rankTable[offset + registration][sn.draw] = cells[registration * 10 + basePoint + 5]
            sportsNavi.rankTable[offset + registration][sn.defeat] = cells[registration * 10 + basePoint + 6]
            sportsNavi.rankTable[offset + registration][sn.gainPoint] = cells[registration * 10 + basePoint + 7]
            sportsNavi.rankTable[offset + registration][sn.lossPoint] = cells[registration * 10 + basePoint + 8]
            sportsNavi.rankTable[offset + registration][sn.goalScore] = cells[registration * 10 + basePoint + 9]
        }
    }
    
    let registration =  sportsNavi.registrationTeams[0] + sportsNavi.registrationTeams[1] + sportsNavi.registrationTeams[2]
    for match in 0...managment.match.count - 1{
        for search in 0...registration - 1 {
            if sportsNavi.shortName[managment.match[match][1]] == sportsNavi.rankTable[search][sn.team]{
                sportsNavi.rank[match][cn.left] = sportsNavi.rankTable[search][sn.rank] + "位"
                sportsNavi.winLoss[match][cn.left] = sportsNavi.rankTable[search][sn.win] + "勝" + sportsNavi.rankTable[search][sn.draw] + "分" + sportsNavi.rankTable[search][sn.defeat] + "敗"
                sportsNavi.score[match][cn.left] = sportsNavi.rankTable[search][sn.gainPoint] + "得点" + sportsNavi.rankTable[search][sn.lossPoint] + "失点"
            }
            if sportsNavi.shortName[managment.match[match][2]] == sportsNavi.rankTable[search][sn.team]{
                sportsNavi.rank[match][cn.right] = sportsNavi.rankTable[search][sn.rank] + "位"
                sportsNavi.winLoss[match][cn.right] = sportsNavi.rankTable[search][sn.win] + "勝" +  sportsNavi.rankTable[search][sn.draw] + "分"  + sportsNavi.rankTable[search][sn.defeat] + "敗"
                sportsNavi.score[match][cn.right] = sportsNavi.rankTable[search][sn.gainPoint] + "得点" + sportsNavi.rankTable[search][sn.lossPoint] + "失点"
            }
        }
    }

    return true
}
