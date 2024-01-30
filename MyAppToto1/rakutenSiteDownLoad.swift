//
//  rakutenSiteDownLoad.swift
//  MyAppToto1
//
//  Created by 岩田嘉吉 on 2018/04/05.
//  Copyright © 2018年 岩田嘉吉. All rights reserved.
//

import Cocoa

func rakutenLotoSite(yyyymm:String) -> ([[Int]]){
    //  MARK:楽天サイトから抽選結果をダンロード
    //  let formatter = DateFormatter()
    //  formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
    //  let now = Date()
    //  print("\(now) start rakutenSiteDownLoad関数 \(homeScreen.sale)")

    var url = URL(string: "https://takarakuji.rakuten.co.jp/backnumber/mini/" + yyyymm)!
    switch lotoManage.category {
    case 0:
        url = URL(string: "https://takarakuji.rakuten.co.jp/backnumber/mini/" + yyyymm)!
    case 1:
        url = URL(string: "https://takarakuji.rakuten.co.jp/backnumber/loto6/" + yyyymm)!
    case 2:
        url = URL(string: "https://takarakuji.rakuten.co.jp/backnumber/loto7/" + yyyymm)!
    default:
        print("rakutenLotoSite error")
    }
    let ss = HttpClientImpl()
    let t = ss.execute(request: URLRequest(url: url))
    let getData: NSString = NSString(data: t.0! as Data, encoding: String.Encoding.utf8.rawValue)!
    let getStr = getData as String
    let backNumber = pickupBackLoto(text: getStr)
    
    return backNumber
}

func pickupBackLoto(text:String)->([[Int]]){
    var length = 0   // 回、年月日、１、２、３、４、５、（loto6６）、（loto７）
    switch lotoManage.category {
    case 0: length = 7
    case 1: length = 8
    case 2: length = 9
    default:
        print("error")
    }
    var returnArray = [[Int]]()
    var textCharacter = Array<String>(repeating: "",count: 11)
    var textStr = ""
    var intArray = [Int]()
    var inspectionString = ""
    var stack = 0
    let keyWord1 = "回号"
    let keyWord2 = "第"
    let keyWord3 = "large"
    let text = text.replacingOccurrences(of: "\t", with: "")
    
    for c in text {
        
        textCharacter[0] = textCharacter[1]
        textCharacter[1] = textCharacter[2]
        textCharacter[2] = textCharacter[3]
        textCharacter[3] = textCharacter[4]
        textCharacter[4] = textCharacter[5]
        textCharacter[5] = textCharacter[6]
        textCharacter[6] = textCharacter[7]
        textCharacter[7] = textCharacter[8]
        textCharacter[8] = textCharacter[9]
        textCharacter[9] = textCharacter[10]
        textCharacter[10] = String(c)
        
        inspectionString = textCharacter[0] + textCharacter[1]
        if ( inspectionString == keyWord1) {
            stack += 1
        }
        
        inspectionString = textCharacter[0]
        
        if (inspectionString == keyWord2) && stack > 0{
            textStr = textCharacter[1] + textCharacter[2] + textCharacter[3] + textCharacter[4]
            intArray.append(Int(textStr)!)
        }
        
        if textCharacter[0] == "2" &&  textCharacter[1] == "0" && textCharacter[4] == "/" &&  textCharacter[7] == "/" {
            let lotteryDate = textCharacter[0] + textCharacter[1] + textCharacter[2] + textCharacter[3] + textCharacter[5] + textCharacter[6] + textCharacter[8] + textCharacter[9]
            intArray.append(Int(lotteryDate)!)
        }
        
        inspectionString = textCharacter[0] + textCharacter[1] + textCharacter[2] + textCharacter[3] + textCharacter[4]
        
        if ( inspectionString == keyWord3)  && stack > 0 && textCharacter[7] != "("{
            
            textStr = textCharacter[7] + textCharacter[8]
            textStr = textStr.replacingOccurrences(of: "<", with: "")
            intArray.append(Int(textStr)!)
        }
        
        if intArray.count == length{
            intArray.append(0)
            returnArray.append(intArray)
            intArray.removeAll()
        }
        
    }
    returnArray.sort { $0[0] > $1[0] }
    //print(returnArray)
    return returnArray
}

