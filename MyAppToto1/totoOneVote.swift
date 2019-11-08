//
//  totoOneVote.swift
//  MyAppToto1
//
//  Created by 岩田嘉吉 on 2017/06/19.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//

import Foundation

struct TotoOneVoteReadControl {
    var s1:Array<String> =  Array<String>(repeating: "",count:11)
    var keyWord:Array<String> = Array<String>(repeating: "",count:6)
    var jpeg:Array<String> =  Array<String>(repeating: "",count:390)
    var push:[[[Int]]] =  [[[Int]]](repeating:[[Int]](repeating: [Int](repeating: 0, count: 3),count: 13),count: 10)
    var mark:[[String]] = [[String]](repeating: [String](repeating: "", count: 10),count: 14)
    var major: Array<String> =  Array<String>(repeating: "",count:13)

    init(s1:Array<String>,jpeg:Array<String>,push:[[[Int]]],mark:[[String]],selection:Array<Int>,appendedTable:[[Int]],major:Array<String>){
        self.s1 = s1
        self.jpeg = jpeg
        self.push = push
        self.mark = mark
        self.major = major
    }
}

var totoOne = TotoOneVoteReadControl(s1: Array<String>(repeating: "",count:11),jpeg: Array<String>(repeating: "",count:390),push:[[[Int]]](repeating:[[Int]](repeating: [Int](repeating: 0, count: 3),count: 13),count: 10),mark:[[String]](repeating: [String](repeating: "", count: 10),count: 14),selection: Array<Int>(repeating:1,count: 10),appendedTable:[[Int]](repeating: [Int](repeating: 0, count: 5),count: 13),major:Array<String>(repeating: "",count:13))

struct ct {             //  ネーミング constant in TotoOneVoteReadControl struct
    static let home = 0
    static let draw = 1
    static let away = 2
    static let major = 3
    static let minor = 4
    static let master = 10
}

var keyWord0 = ["y","o","s","o","u","_","1",".","p","n","g"]
var keyWord1 = ["y","o","s","o","u","_","1","m","a","r","k"]
var keyWord2 = ["y","o","s","o","u","_","0",".","p","n","g"]
var keyWord3 = ["y","o","s","o","u","_","0","m","a","r","k"]
var keyWord4 = ["y","o","s","o","u","_","2",".","p","n","g"]
var keyWord5 = ["y","o","s","o","u","_","2","m","a","r","k"]
var keyWord6 = [" ","g","p","P","r","o","f","N","a","m","e"]

var mark0 = "yosou_1.png"
var mark1 = "yosou_1mark"
var mark2 = "yosou_0.png"
var mark3 = "yosou_0mark"
var mark4 = "yosou_2.png"
var mark5 = "yosou_2mark"

func totoOneVoteRead ()->Bool{
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
    //  let now = Date()
    //  print("\(now) start TotoOneVoteRead関数")
    //  MARK:totoONEグランプリ みんなの予想データを読み取り
    multSCreen.totoOnetotal = [Int](repeating: 0, count: 3)
    multSCreen.aggregate =  [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
    multSCreen.minimumPrize = 0
    multSCreen.maximumPrize = 0
    multSCreen.mark = Array<Int>(repeating: 0,count:5)
    multSCreen.singleDispPage = 0
    multiView.goDraw = cd.erase
    managment.bed = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
    totoOne.jpeg =  Array<String>(repeating: "",count: 390)
    totoOne.mark = [[String]](repeating: [String](repeating: "", count: 10),count: 15)

    var checkPoint = 0
    let textFileName = "my toto.html"
    let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    let targetTextFilePath = documentDirectoryFileURL?.appendingPathComponent(textFileName)

    do {
        let text = try String(contentsOf: targetTextFilePath!, encoding: String.Encoding.utf8)
    
        if text.contains(String("第" + String(homeScreen.user[ch.sale]) + "回")){
            //  MARK: 予想者の名前を編集
            //  キーワード[" gpProfName”からの相対位置で名前を特定
            var temp:Array<String> =  Array<String>(repeating: "",count:11)
            var stack = 0
            var point = 0
            var str = ""
            
            for c in text {
                
                totoOne.s1[0] = totoOne.s1[1]
                totoOne.s1[1] = totoOne.s1[2]
                totoOne.s1[2] = totoOne.s1[3]
                totoOne.s1[3] = totoOne.s1[4]
                totoOne.s1[4] = totoOne.s1[5]
                totoOne.s1[5] = totoOne.s1[6]
                totoOne.s1[6] = totoOne.s1[7]
                totoOne.s1[7] = totoOne.s1[8]
                totoOne.s1[8] = totoOne.s1[9]
                totoOne.s1[9] = totoOne.s1[10]
                totoOne.s1[10] = String(c)
                
                if (totoOne.s1 == keyWord6) {
                   stack = 0
                }
                stack += 1
                if stack >= 94 && stack <= 107{  //  ここは目で数えるしかない
                    str = str + String(c)
                }
                if stack == 108{
                    temp[point] = str
                    point += 1
                    str = ""
                }
            }
            for i in 0...ct.master - 1 {
                totoOne.mark[13][i] = temp[i + 1]
                totoOne.mark[13][i] = totoOne.mark[13][i].replacingOccurrences(of: "\t", with: "")
                let split = totoOne.mark[13][i].components(separatedBy: "\n")
                totoOne.mark[13][i] = split[0]
            }
            //  MARK: 予想者の投票内容を編集
            for c in text{
                totoOne.s1[0] = totoOne.s1[1]
                totoOne.s1[1] = totoOne.s1[2]
                totoOne.s1[2] = totoOne.s1[3]
                totoOne.s1[3] = totoOne.s1[4]
                totoOne.s1[4] = totoOne.s1[5]
                totoOne.s1[5] = totoOne.s1[6]
                totoOne.s1[6] = totoOne.s1[7]
                totoOne.s1[7] = totoOne.s1[8]
                totoOne.s1[8] = totoOne.s1[9]
                totoOne.s1[9] = totoOne.s1[10]
                totoOne.s1[10] = String(c)

                if (totoOne.s1 == keyWord0 || totoOne.s1 == keyWord1 || totoOne.s1 == keyWord2 || totoOne.s1 == keyWord3 || totoOne.s1 == keyWord4 || totoOne.s1 == keyWord5) {

                    totoOne.jpeg[checkPoint] = totoOne.s1[0] + totoOne.s1[1] + totoOne.s1[2] + totoOne.s1[3] + totoOne.s1[4] + totoOne.s1[5] + totoOne.s1[6] + totoOne.s1[7] + totoOne.s1[8] + totoOne.s1[9] + totoOne.s1[10]

                    checkPoint += 1
                }
            }
            //  print(totoOne.jpeg)   //  totoOne.htmlのレイアウトが変わったらここに戻っておいで
            for master in 0...ct.master - 1 {
                for match in 0...managment.match.count - 1 {
                    if totoOne.jpeg[master * 39 + match * 3] == "yosou_1mark"{
                        totoOne.mark[match][master] = totoOne.mark[match][master] + "a"
                    }
                    if totoOne.jpeg[master * 39 + match * 3 + 1] == "yosou_0mark"{
                        totoOne.mark[match][master] = totoOne.mark[match][master] + "b"
                    }
                    if totoOne.jpeg[master * 39 + match * 3 + 2] == "yosou_2mark"{
                        totoOne.mark[match][master] = totoOne.mark[match][master] + "c"
                    }
                }
            }
        }
    } catch _ as NSError {
        print("totoOneVoteRead error")
        return false
    }
    for match in 0...managment.match.count - 1{
        for master in 0...ct.master - 1{
            totoOne.mark[match][master] = replaceMark(mark: totoOne.mark[match][master])
        }
    }
    return true
}

//  引き分け「0」がデータが存在した上での０なのか、何にもない０なのか紛らわしいため「１」「０」「２」の内部表現として「a」「b」「c」を使用する

func replaceMark(mark:String) -> String{
    //  MARK:内部表現「a」「b」「c」を「1」「0」「2」へ変換
    if mark == "a"{
        return "[1][▒][▒]"
    }else if mark == "b"{
        return "[▒][0][▒]"
    }else if mark == "c"{
        return "[▒][▒][2]"
    }else if mark == "ab"{
        return "[1][0][▒]"
    }else if mark == "ac"{
        return "[1][▒][2]"
    }else if mark == "bc"{
        return "[▒][0][2]"
    }else if mark == "abc"{
        return "[1][0][2]"
    }
    return ""
}

func reverseMark(mark:String) -> String {
    //  MARK:「1」「0」「2」を内部表現「a」「b」「c」に変換
    if mark == "[1][▒][▒]"{
        return "a"
    }else if mark == "[▒][0][▒]"{
        return "b"
    }else if mark == "[▒][▒][2]"{
        return "c"
    }else if mark == "[1][0][▒]"{
        return "ab"
    }else if mark == "[1][▒][2]"{
        return "ac"
    }else if mark == "[▒][0][2]"{
        return "bc"
    }else if mark == "[1][0][2]"{
        return "abc"
    }
    return ""
}
