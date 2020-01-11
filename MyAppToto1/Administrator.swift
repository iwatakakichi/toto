//
//  Administrator.swift
//  totoVer1.0.1
//
//  Created by 岩田嘉吉 on 2017/05/19.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//

import Cocoa


/*
 ** 管理者クラス
 */

struct ManagersManagment {
    var match = [[String]](repeating: [String](repeating: "", count: 3),count: 13)  //  試合No. HOME AWAY
    var vote = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)  //  HOME DRAY AWAY
    var rate = [[Float]](repeating: [Float](repeating: 0, count: 3),count: 13) //  HOME DRAY AWAY
    var rateDisp = [[String]](repeating: [String](repeating: "", count: 3),count: 13) //  HOME DRAY AWAY
    var bed = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)                    //  ◯の印がついた時は１、◎の印がついた時は２
    var judge =  [[Int]](repeating: [Int](repeating: 0, count: 4),count: 8) //  一等推定金額から穴〜15%まで
    var userDefault: Array<Int> = Array<Int>(repeating: 0,count:24)
    init(match:[[String]],vote:[[Int]],rate :[[Float]],rateDisp:[[String]],bed: [[Int]],judge: [[Int]],userDefault: [Int]) {
        self.match = match
        self.vote = vote
        self.rateDisp = rateDisp
        self.rate = rate
        self.bed = bed
        self.judge = judge
        self.userDefault = userDefault
    }
    
    mutating func calcRate() {
        // Rate[[]]生成
        let sales = self.vote[0][0] + self.vote[0][1] + self.vote[0][2]
        // print("売り上げ = \(sales).....")
        if sales > 0{
            for match in 0...self.match.count - 1{
                for j in 0...2{
                    self.rate[match][j] = Float((self.vote[match][j] * 10000 / sales)) / 10000
                }
            }
            //    rateDisp  float 0.23519 を string 23.52 に変換
            var subString1 = " "
            var subString2 = " "
            for match in 0...self.match.count - 1 {
                for j in 0...2 {
                    if  self.rate[match][j] != 0{
                        let itemp = Int(self.rate[match][j] * 10000)
                        let str = String(itemp)
                        if self.rate[match][j] < 0.1{
                            subString1 = String(str.prefix(1))
                            subString2 = String(str.suffix(2))
                        }else{
                            subString1 = String(str.prefix(2))
                            subString2 = String(str.suffix(2))
                        }
                        let Cstr = subString1 + "." + subString2
                        self.rateDisp[match][j] = Cstr
                    }
                }
            }
        }
    }
    
    mutating func initialize() {
        for matchNo  in 0...self.match.count - 1 {
            for j in 0...2{
                self.match[matchNo][j]  = ""
                self.vote[matchNo][j] = 0
                self.rate[matchNo][j] = 0.0
                self.rateDisp[matchNo][j] = ""
                self.bed[matchNo][j] = 0
           }
        }
    }
    
    mutating func setUserDefault() {
        let upperLimit = self.judge.count - 1
        for i in 0...upperLimit{
            self.userDefault[i] = self.judge[i][0]    // mm.judge
            self.userDefault[i + 8] = self.judge[i][1]    // mm.low
            self.userDefault[i + 16] = self.judge[i][2]  //  mm.high
        }
    }
    
    mutating func setJudge() {
        for i in 0...self.judge.count - 1{
            self.judge[i][0] = self.userDefault[i]   // mm.judge
        }
        for i in 0...self.judge.count - 1{
            self.judge[i][1] = self.userDefault[i + 8]   // mm.low
        }
        for i in 0...self.judge.count - 1{
            self.judge[i][2] = self.userDefault[i + 16]//  mm.high
        }
    }
}

struct cm {                 //  ネーミング constant in ManagersManagment struct
    static let homeTeam = 1
    static let awayTeam = 2
    static let home = 0
    static let draw = 1
    static let away = 2
    static let prize = 0
    static let majorWin = 1
    static let minorWin = 2
    static let drawMatch = 3
    static let homeWin = 4
    static let awayWin = 5
    static let under25 = 6
    static let under15 = 7
    static let judge = 0
    static let low = 1
    static let high = 2
    static let count = 3
}

var managment = ManagersManagment(match: [[String]](repeating: [String](repeating: "", count: 3),count: 13), vote: [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13),rate : [[Float]](repeating: [Float](repeating: 0, count: 3),count: 13) ,rateDisp : [[String]](repeating: [String](repeating: "", count: 3),count: 13),bed: [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13),judge: [[1,1000,7000,0],[1,6,7,0],[1,1,6,0],[1,1,6,0],[1,1,9,0],[1,1,7,0],[0,2,2,0],[0,1,1,0]],userDefault: Array<Int>(repeating: 0,count:24))

//  MARK:  HomeScreenControl
struct HomeScreenControl {
    var user: Array<Int> = Array<Int>(repeating: 0,count:5)
    var matchResult: Array<Int> = Array<Int>(repeating: 0,count:13)
    var prize: Int
    var announcement: Int
    var sale: String

    init(user: [Int],matchResult:[Int],prize: Int,announcement:Int,sale: String){
        self.user = user
        self.matchResult = matchResult
        self.prize = prize
        self.announcement = announcement
        self.sale = sale
    }
}

struct ch {
    static let sale = 0
    static let prospectsSales = 1
    static let carryOver = 2
    static let totoPs = 3
    static let announcement = 4
}

var homeScreen = HomeScreenControl(user:[1121,200_000_000,0,0,0],matchResult:Array<Int>(repeating: 0,count:13),prize:0,announcement:0,sale:"")

//  MARK:  MultiScreenControl
struct MultiScreenControl {
    var forecast:Array<Int> = Array<Int>(repeating: 0,count:13)
    var totoOnetotal:Array<Int> = Array<Int>(repeating: 0,count:3)
    var aggregate: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
    var minimumPrize: Int
    var maximumPrize: Int
    var mark: Array<Int> = Array<Int>(repeating: 0,count:5)
    var singleDispPage:Int
    var master: Int
    var stamp: Int
    var notice:Int
    var noticeDisp = [[String]](repeating: [String](repeating: "", count: 3),count: 13)
    init(forecast:[Int],totoOnetotal:[Int],aggregate:[[Int]],minimumPrize: Int,maximumPrize: Int,mark: [Int],singleDispPage:Int,master:Int,stamp:Int,notice:Int,noticeDisp:[[String]]){
        self.forecast = forecast
        self.totoOnetotal = totoOnetotal
        self.aggregate = aggregate
        self.minimumPrize = minimumPrize
        self.maximumPrize = maximumPrize
        self.mark = mark
        self.singleDispPage = singleDispPage
        self.master = master
        self.stamp = stamp
        self.notice = notice
        self.noticeDisp = noticeDisp
    }
    
    mutating func initialize() {
        self.totoOnetotal = [Int](repeating: 0, count: 3)
        self.aggregate =  [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
        self.minimumPrize = 0
        self.maximumPrize = 0
        self.mark = Array<Int>(repeating: 0,count:5)
        self.singleDispPage = 0
        self.master = 0
    }
}

struct ms {
    static let single = 0
    static let double = 1
    static let triple = 2
    static let multi = 3
    static let afterCompression = 4
}

var multSCreen = MultiScreenControl(forecast: [Int](repeating: 0, count: 13),totoOnetotal: [Int](repeating: 0, count: 3),aggregate: [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13) ,minimumPrize: 0,maximumPrize: 0,mark: Array<Int>(repeating: 0,count:5),singleDispPage:0,master:0,stamp:0,notice:0,noticeDisp : [[String]](repeating: [String](repeating: "", count: 3),count: 13))

let textFileName = "totoOne.html"
let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
let targetTextFilePath = documentDirectoryFileURL?.appendingPathComponent(textFileName)

let  HomeSCreenGuidance1 = "\n\n\n\n\n\n" +
                       "通常予想操作手順　開催情報（クリック）→投票状況（クリック）→マルチ（クリック）\n" +
                       "トトワン参考手順　開催情報（クリック）→投票状況（クリック）→トトワン検索（クリック）→マルチ（クリック）\n" +
                       "結果チェック手順　くじ結果（クリック）→チェック（クリック）\n" +
                       "なお、開催ごとに開催回、売上予想、キャリーオーバー（任意）の入力を行って下さい。\n\n" +
                       "トトワン検索を行うため、別途 my toto.htmlファイルが必要です。簡易マニュアルを参考に用意して下さい（任意）。\n" +
                       "書類(/Users/ユーザ名/Documents/)内の my toto.html、ticket.csv、teamName.csv及びX-????.csv(?は数字)は\n" +
                       "予約されています。これらの名前のファイルをお使いの方は、本ソフトの利用をご遠慮下さい。"

let  MultSCreenGuidance2 = "別途 my toto.htmlファイルが必要です。\n\n" +
                       "my toto.htmlファイルの更新を、行って下\n" +
                       "さい。ブラウザsafariで「サーカーくじtoto\n" +
                       "のNo.１ポータルサイトtotoONEトトワン」\n" +
                       "(http://www.totoone.jp)を開き、totoO\n" +
                       "NEグランプリ、みんなの予想を見る、他のユ\n" +
                       "ーザーの予想一覧と移動後、totoONEグラン\n" +
                       "プリの通算的中率、新着順、いいね！順、当\n" +
                       "選ポイント順の区分とフォローユーザ、全て\n" +
                       "の別をクリックします。表示された画面を、\n" +
                       "Safariメニューバーから/ファイル/別名で保\n" +
                       "存.../書き出し名:my my toto.html/場所:書類\n" +
                       "へ保存して下さい。"
//  MARK: SingleScreenControl
struct SingleScreenControl {
    var one = [String](repeating:"",count: 30)
    var all = [[String]](repeating: [String](repeating: "", count: 10),count: 30)
    var display = [[String]](repeating: [String](repeating: "", count: 10),count: 27)
    var noneDisplay = [[Int]](repeating: [Int](repeating: 0, count: 10),count: 2)
    var filtter:Array<String> = Array<String>()
    var stamp: Int
    var pageNo: Int
    var sort: Int
    var choisu: Int //  表示切り替え　マーク→　チーム→　投票率
    
    init(one:Array<String>,all: [[String]],display: [[String]],noneDisplay:[[Int]],filtter:Array<String>,stamp:Int,pageNo:Int,sort: Int, choisu: Int) {
        self.one = one
        self.all = all
        self.display = display
        self.noneDisplay = noneDisplay
        self.filtter = filtter
        self.stamp = stamp
        self.pageNo = pageNo
        self.sort = sort
        self.choisu = choisu
    }
    mutating func initialize() {
        self.one = [String](repeating:"",count: 30)
        self.all = [[String]](repeating: [String](repeating: "", count: 10),count: 30)
        self.display = [[String]](repeating: [String](repeating: "", count: 10),count: 27)
        self.noneDisplay = [[Int]](repeating: [Int](repeating: 0, count: 10),count: 2)
        self.filtter = Array<String>()
        self.pageNo = 0
        self.sort = 0
        self.choisu = 0
    }
}

struct cs {                   //  ネーミング constant in　SingleScreenControl　struct
    static let mark = 0       // choisu 1,0,2マーク
    static let team = 1       // choisu　チーム名
    static let rate = 2       // choisu　投票率
    static let prize = 0      // sort 当選金額順
    static let mainstream = 1 // sort　◎の合計数
    static let outOfSelection = 0
    static let choosing = 1
    static let displayColumnSize = 10
    static let displayRowSize = 27
    static let noneDisplayfirstOrder = 0
    static let noneDisplayLastOrder = 1
}

var singleScreen = SingleScreenControl(one: [String](repeating:"",count: 30),all: [[String]](repeating: [String](repeating: "", count: 10),count: 30),display: [[String]](repeating: [String](repeating: "", count: 10),count: 27),noneDisplay: [[Int]](repeating: [Int](repeating: 0, count: 10),count: 2),filtter: Array<String>(),stamp: 0,pageNo: 1,sort: 0, choisu: 0)

//  MARK: CheckScreenControl
struct CheckScreenControl {
    var one = [String](repeating:"",count: 34)
    var all = [[String]](repeating: [String](repeating: "", count: 10),count: 34)
    var display = [[String]](repeating: [String](repeating: "", count: 10),count: 28)
    var result:Array<String> = Array<String>(repeating: "",count:28)
    var stamp: Int
    var pageNo: Int
    var sort: Int
    var choisu: Int
    init(one:Array<String>,all: [[String]],display: [[String]],result:Array<String>,stamp:Int,pageNo:Int,sort: Int, choisu: Int) {
        self.one = one
        self.all = all
        self.display = display
        self.result = result
        self.stamp = stamp
        self.pageNo = pageNo
        self.sort = sort
        self.choisu = choisu    //  表示切り替え　マーク→　結果→　チーム
    }
    mutating func initialize() {
        self.one = [String](repeating:"",count: 34)
        self.all = [[String]](repeating: [String](repeating: "", count: 10),count: 34)
        self.display = [[String]](repeating: [String](repeating: "", count: 10),count: 28)
        self.result = Array<String>(repeating: "",count:28)
        self.pageNo = 0
        self.sort = 0
        self.choisu = 0
    }
}

struct cc {                         //  ネーミング constant in CheckScreenControl struct
    static let mark = 0             // choisu　1,0,2マーク
    static let rezult = 1           // choisu  結果
    static let team = 2             // choisu  チー
    static let mainStream = 0       // sort ◎の数
    static let hit = 1              // sort あたりの数
    static let difficulty = 2       // sort 当選確率
    static let displayColumnSize = 10
    static let displayRowSize = 27
}

var checkScreen = CheckScreenControl(one: [String](repeating:"",count: 34),all: [[String]](repeating: [String](repeating: "", count: 10),count: 34),display: [[String]](repeating: [String](repeating: "", count: 10),count: 28),result: Array<String>(repeating: "",count:28),stamp:0,pageNo: 1,sort: 0, choisu: 0)

//  MARK: RezaltScreenControl
struct ResultScreenControl {
    var saleTable:Array<Int> = Array<Int>()
    var salezDisplayTable = Array<Int>(repeating: 0,count:24)
    var bothSideTable = [[String]](repeating: [String](repeating: "", count: 24),count: 28)
    var upperSideTable = [[String]](repeating: [String](repeating: "", count: 12),count: 28)
    var lowerSideTable = [[String]](repeating: [String](repeating: "", count: 12),count: 28)
    var markTable =  [[String]]()
    var rateTable =  [[String]]()
    var teamTable =  [[String]]()
    var winningMoneyCount: Int
    var favoriteCount: Int
    var homeWinCount: Int
    var wakeWinCount: Int
    var aweyWinCount: Int
    var conditionClearCount: Int
    var choice: Int
    var page: Int
    var saveUser: Array<Int> = Array<Int>()
    var stockYear: Int
    var labelYear: Int
    
    init(saleTable:Array<Int>,saleDisplayTable:Array<Int>,bothSideTable:[[String]],upperSideTable:[[String]],lowerSideTable:[[String]],markTable:[[String]],rateTable:[[String]],teamTable:[[String]], winningMoneyCount:Int,favoriteCount:Int,homeWinCount: Int,wakeWinCount: Int,aweyWinCount: Int,conditionClearCount: Int,choice: Int,page: Int,saveUser: Array<Int>,stockYear:Int,labelYear:Int) {
        self.saleTable = saleTable
        self.salezDisplayTable = saleDisplayTable
        self.bothSideTable = bothSideTable
        self.upperSideTable = upperSideTable
        self.lowerSideTable = lowerSideTable
        self.markTable = markTable
        self.rateTable = rateTable
        self.teamTable = teamTable
        self.winningMoneyCount = winningMoneyCount
        self.favoriteCount = favoriteCount
        self.homeWinCount = homeWinCount
        self.wakeWinCount = wakeWinCount
        self.aweyWinCount = aweyWinCount
        self.conditionClearCount = conditionClearCount
        self.choice = choice
        self.page = page
        self.saveUser = saveUser
        self.stockYear = stockYear
        self.labelYear = labelYear
    }
}

struct cr {             //  ネーミング constant in ResultScreenControl struct
    static let mark = 0 // choice 1,0,2マーク
    static let team = 1 // choice チーム名
    static let rate = 2 // choice 投票率
    static let displayMaximumSize = 24
    static let displayColumunSize = 12
    static let displayRowSize = 28
}
    
var resultScreen = ResultScreenControl(saleTable:[Int](),saleDisplayTable: [Int](repeating:0,count: 24),bothSideTable: [[String]](repeating: [String](repeating: "", count: 24),count: 28),upperSideTable: [[String]](repeating: [String](repeating: "", count: 12),count: 28),lowerSideTable: [[String]](repeating: [String](repeating: "", count: 12),count: 28),markTable: [[String]](repeating: [String](repeating: "", count: 24),count: 13),rateTable: [[String]](repeating: [String](repeating: "", count: 24),count: 13),teamTable: [[String]](repeating: [String](repeating: "", count: 24),count: 13),winningMoneyCount:0,favoriteCount:0,homeWinCount: 0,wakeWinCount: 0,aweyWinCount:0,conditionClearCount:0,choice:0,page:1,saveUser: [Int](repeating:0,count: 5),stockYear:0,labelYear:0)

//  MARK: TotoOneScreenControl
struct TotoOneScreenControl {
    var uppersideTable = [[String]](repeating: [String](repeating: "", count: 10),count: 15)
    var undersideTable = [[String]](repeating: [String](repeating: "", count: 10),count: 14)
    var appendedTable:[[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 5),count: 13)
    var selection: Array<Int> =  Array<Int>(repeating: 1,count:10)
    var hitCount = [Int]()
    var lowerLeftSideTabel = [[Int]]()
    var difference: Int
    var remarks:Int
    var stamp: Int
    var popularityBed = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
    var differenceBed = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13)
    var accountingRules: Int = 0
    
    init(uppersideTable:[[String]],undersideTable:[[String]],appendedTable:[[Int]],selection:Array<Int>,hitCount:[Int],lowerLeftSideTabel:[[Int]],difference: Int,remarks:Int,stamp: Int,popularityBed: [[Int]],differenceBed: [[Int]],accountingRules:Int) {
        self.uppersideTable = uppersideTable
        self.undersideTable = undersideTable
        self.appendedTable = appendedTable
        self.selection = selection
        self.hitCount = hitCount
        self.lowerLeftSideTabel = lowerLeftSideTabel
        self.difference = difference
        self.remarks = remarks
        self.stamp = stamp
        self.popularityBed = popularityBed
        self.differenceBed = differenceBed
        self.accountingRules = accountingRules
    }
    mutating func initialize() {
        self.uppersideTable = [[String]](repeating: [String](repeating: "", count: 10),count: 15)
        self.undersideTable =  [[String]](repeating: [String](repeating: "", count: 10),count: 14)
        self.hitCount = Array<Int>(repeating: 0,count:10)
        self.lowerLeftSideTabel =  [[Int]](repeating: [Int](repeating: 0, count: 5),count: 13)
    }
}

struct co {             //  ネーミング constant in Toto(O)neScreenControl struct
    static let displayColumnSize = 10
}

var totoOneScreen = TotoOneScreenControl(uppersideTable: [[String]](repeating: [String](repeating: "", count: 10),count: 15),undersideTable: [[String]](repeating: [String](repeating: "", count: 10),count: 14),appendedTable:[[Int]](repeating: [Int](repeating: 0, count: 5),count: 13),selection: Array<Int>(repeating:1,count: 10),hitCount:  Array<Int>(repeating: 0,count:10),lowerLeftSideTabel: [[Int]](repeating: [Int](repeating: 0, count: 5),count: 13),difference: 0,remarks:0,stamp: 0,popularityBed: [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13),differenceBed: [[Int]](repeating: [Int](repeating: 0, count: 3),count: 13),accountingRules:5)

let  totoOneScreenGuidance =
    "別途 my toto.htmlファイルが必要です。ブラウザsafariで「サーカーくじtotoのNo.１ポータルサイトtotoONEトトワン」(http://www.totoone.jp)を開き、totoONEグランプリ、みんなの予想を見る、\n" +
    "他のユーザーの予想一覧と移動後、totoONEグランプリの通算的中率、新着順、いいね！順、当選ポイント順の区分とフォローユーザ、全ての別をクリックします。表示された画面を、Safariメニューバー\n" +
    "から/ファイル/別名で保存.../書き出し名:my toto.html/場所:書類へ保存して下さい。この画面は、ウインドウを閉じる（赤○クリックで）一旦閉じてください。再度トトワン検索からやり直してください。\n" +
    "なお、面倒臭い、わずらわしいと感じた方は、この手順をスッキプしてマルチ（クリック）へ進んで下さい。書類のファイルパスは、"


//  MARK: Ticket
struct ticket {
    var mark:Array<Int> = Array<Int>(repeating:0,count:13)
    var rank:Array<Int> =  Array<Int>(repeating:0,count:9)
    var prize: Int
    var winner: Int
    var difficulty: Int
    var major: Int
    var minor: Int
    var draw: Int
    var mainstream: Int
    var hit: Int
    var firstOrder: Int
    var lastOrder: Int
    var buyer: String

    init(mark:Array<Int>,rank:Array<Int>,prize: Int,winner:Int,difficulty: Int, major: Int, minor: Int,draw:Int,mainstream:Int,hit: Int,firstOrder: Int,lastOrder: Int,buyer: String) {
        self.mark = mark
        self.rank =  rank
        self.prize = prize
        self.winner = winner
        self.difficulty = difficulty
        self.major = major
        self.minor = minor
        self.draw = draw
        self.mainstream = mainstream
        self.hit = hit
        self.firstOrder = firstOrder
        self.lastOrder = lastOrder
        self.buyer = buyer
    }
}

var firstOrderTicket = (mark:Array<Int>(repeating: 0,count:13),rank:Array<Int>(repeating: 0,count:9),prize: 0,winner:0,difficulty: 0, major: 0, minor: 0,draw:0,mainstream:0,hit: 0,firstOrder: 0,lastOrder: 0,buyer: "")
var firstOrderTickets = [firstOrderTicket]

var buyTicket = (mark:Array<Int>(repeating: 0,count:13),rank:Array<Int>(repeating: 0,count:9),prize: 0,winner:0,difficulty: 0, major: 0, minor: 0,draw:0,mainstream:0,hit: 0,firstOrder: 0,lastOrder: 0,buyer: "")
var buyTickets = [buyTicket]

var temporaryTicket = (mark:Array<Int>(repeating: 0,count:13),rank:Array<Int>(repeating: 0,count:9),prize: 0,winner:0,difficulty: 0, major: 0, minor: 0,draw:0,mainstream:0,hit: 0,firstOrder: 0,lastOrder: 0,buyer: "")
var temporaryTickets = [temporaryTicket]

// MARK: numeric check
func isOnlyNumber(_ str:String) -> Bool {
    let predicate = NSPredicate(format: "SELF MATCHES '\\\\d+'")
    return predicate.evaluate(with: str)
}
// MARK: transfromFromZeroToBlank
func transfromFromZeroToBlank(inDt:Int)->String {
    if inDt == 0{
       return ""
    }
    return separateComma(num:inDt)
}
// MARK: transfromFromBlankToZero
func transfromFromBlankToZero(inDt:String?)->Int {
    if inDt != ""{
        let str = inDt!.replacingOccurrences(of: ",", with: "")
        return Int(str)!
    }
    return 0
}
//  MARK: べき乗
infix operator ^^
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
//  MARK: カンマ区切り
func separateComma(num:Int) -> String {
    let formatter = NumberFormatter()
    formatter.groupingSeparator = ","
    formatter.numberStyle = .decimal
    return formatter.string(from: num as NSNumber)!
}
//  MARK: 同期通信
public class HttpClientImpl {
    
    private let session: URLSession
    
    public init(config: URLSessionConfiguration? = nil) {
        self.session = config.map { URLSession(configuration: $0) } ?? URLSession.shared
    }
    
    public func execute(request: URLRequest) -> (NSData?, URLResponse?, NSError?) {
        var d: NSData? = nil
        var r: URLResponse? = nil
        var e: NSError? = nil
        let semaphore = DispatchSemaphore(value: 0)
        session
            .dataTask(with: request) { (data, response, error) -> Void in
                d = data as NSData?
                r = response
                e = error as NSError?
                semaphore.signal()
            }
            .resume()
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return (d, r, e)
    }
}
