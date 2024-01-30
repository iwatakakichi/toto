//
//  ViewControllerLoto.swift
//  MyAppToto1
//
//  Created by 岩田嘉吉 on 2018/04/05.
//  Copyright © 2018年 岩田嘉吉. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewControllerLoto: NSViewController {
    var audioName: String = "decision1"
    let audioPath = NSURL()
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var kaigo: NSTextField!
    @IBOutlet weak var radioButton: NSMatrix!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var winMairix: NSMatrix!
    @IBOutlet weak var carMatrix: NSMatrix!
    @IBOutlet weak var drivingModeBUtton: NSButton!
    @IBOutlet weak var labelCount: NSTextField!
    @IBOutlet weak var numericKeypadMatrix: NSMatrix!
    @IBOutlet weak var selectionMatrix: NSMatrix!
    @IBOutlet weak var hittitle: NSTextField!
    @IBOutlet weak var hitMatrix: NSMatrix!
    @IBOutlet weak var rejectionMatrix: NSMatrix!
    @IBOutlet weak var groupMatrix: NSMatrix!
    @IBOutlet weak var colorButton: NSButton!
    @IBOutlet weak var lastWinMatrix: NSMatrix!
    @IBOutlet weak var average: NSTextField!
    @IBOutlet weak var labelA: NSTextField!
    @IBOutlet weak var labelB: NSTextField!
    @IBOutlet weak var labelC: NSTextField!
    @IBOutlet weak var labelD: NSTextField!
    @IBOutlet weak var labelE: NSTextField!
    @IBOutlet weak var markBallMatrix: NSMatrix!
    @IBOutlet weak var scoreCheckMatrix: NSMatrix!
    @IBOutlet weak var quickPickMatrix: NSMatrix!
    @IBOutlet weak var nextQuickLabel: NSTextField!
    @IBOutlet weak var labelScore5: NSTextField!
    @IBOutlet weak var labelScore6: NSTextField!
    @IBOutlet weak var overallsMatrix: NSMatrix!
    @IBOutlet weak var recentlyMatrix: NSMatrix!
    @IBOutlet weak var scoMatrix: NSMatrix!
    @IBOutlet weak var averageMatrix: NSMatrix!
    @IBOutlet weak var lableNear: NSTextField!
    @IBOutlet weak var labelMax: NSTextField!
    @IBOutlet weak var labelMiddle: NSTextField!
    @IBOutlet weak var scaaleMatrix: NSMatrix!
    @IBOutlet weak var checkBoxMatrix: NSMatrix!
    @IBOutlet weak var kanaMatrix: NSMatrix!
    @IBOutlet weak var textSpeed: NSTextField!
    @IBOutlet weak var mySlider: NSSlider!
    @IBOutlet weak var popUpButton: NSPopUpButton!
    @IBOutlet weak var graphCategoryButton: NSMatrix!
    @IBOutlet weak var mediumValue: NSTextField!
   
    var timer: Timer!
    var sort = 0
    var numberIn = 0
    var numberMatch = 0
    var Kilometers = -1
    var beforeSecond  = 0
    var nextQuick = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setAudio()
        if lotoManage.graphCategory ==  gc.dotChart.rawValue{
            graphCategoryButton.setState(1, atRow: 0, column: 1)
        }
        let strs = ["set い","set ろ","set は","set に"]
        popUpButton.removeAllItems()
        for str in strs{
            popUpButton.addItem(withTitle: str)
        }
        var _ = defaultsLoad()
       
        lotoManage.counter = 0
        lotoManage.distribution.sort { $0[0] < $1[0] }
        
        timer = Timer.scheduledTimer(timeInterval: lotoManage.cpuTimeInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    
        for cell in 0...lotoManage.markOfloto - 1{
            lastWinMatrix.cells[cell].stringValue = transfromFromZeroToKome(inDt: lotoManage.lastWinNumber[cell])
        }
        var _ = changeTheKeyPad()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    //  MARK:乱数発生から、条件判定まで
    @objc func update(tm: Timer) {

        for row in 0...4{
            lotoManage.counter += 1
            if lotoManage.quickPick[row] == off {
                lotoManage.judgmentResult = Array<Int>(repeating: off,count:6)
            
                printTimeElapsedWhenRunningCode(title: "Shuffle lazy") {
                    let lotoArray = Array(0...lotoManage.sizeOfloto - 1)
                    lotoManage.mark[row] = Array(LazyShuffledSequence(elements: lotoArray).prefix(lotoManage.markOfloto))
                    
                    for column in 0...lotoManage.markOfloto  - 1{
                        lotoManage.mark[row][column] += 1
                    }
                }
                
                lotoManage.mark[row].sort()
                lotoManage.judgmentResult = searchEngine(inDt: lotoManage.mark[row])
            
                //  MARK:アイドリングモードのときの処理
                if  lotoManage.drivingMode == off {
                    //  MARK:表示色編集
                    var _ = blackMark(inDt:row)
                    var _ = setShuffleNumber(inDt:row)
                    if lotoManage.judgmentResult[cb.continuousNumber.rawValue] == on{
                        for column in 0...lotoManage.markOfloto - 2{
                            if lotoManage.mark[row][column] + 1 == lotoManage.mark[row][column + 1] {
                                var _ = magentaMark(inDt:row)
                            }
                        }
                    }
                    
                    if  lotoManage.judgmentResult == Array<Int>(repeating: on,count:6) && lotoManage.selectionNumber != Array<Int>(repeating: 0,count:7){
                        var _ = redMark(inDt:row)
                    }
                    
                }
                //  MARK:ドライブモードで条件クリアのときの処理
                if lotoManage.drivingMode == on {
                    if  lotoManage.judgmentResult == Array<Int>(repeating: on,count:6) {
                        lotoManage.quickPick[row] = on
                        var _ = blackMark(inDt:row)
                        var _ = setShuffleNumber(inDt:row)
                        var _ = redMark(inDt:row)
                        hittitle.stringValue = "条件をクリア"
                        for cell in 0...lotoManage.hitRezult.count - 1 {
                            if lotoManage.conditionsSet[lotoManage.category][cell] == on{
                                hitMatrix.cells[cell].stringValue = transfromFromZeroToBlank(inDt: lotoManage.hitRezult[cell])
                            }
                        }
                    }
                }
                //  MARK:アイドリングモードのときの処理
                //  出現回数の記録
                if  lotoManage.drivingMode == off {
                    if lotoManage.judgmentResult[cb.continuousNumber.rawValue] == on{
                        for column in 0...lotoManage.markOfloto - 1{
                            let point = lotoManage.mark[row][column] - 1
                            lotoManage.occurrences[point] += 1
                        }
                    }
                }
            }
    
            //  スコア
            var score = 0
            for cell in 0...lotoManage.markOfloto - 1{
                score += lotoManage.distribution[lotoManage.mark[row][cell] - 1][2]
                //  print("番号 \(lotoManage.mark[row][cell]) の出現回数は \(lotoManage.distribution[lotoManage.mark[row][cell] - 1][2])  scoreは \(score)  ")
            }
            if  lotoManage.drivingMode == off || lotoManage.quickPick[row] == on {
                scoMatrix.cells[row].stringValue = "score..." + String(score)
                if score > 0 {
                    averageMatrix.cells[row].stringValue = String(format: "%.1f",average(inDt:lotoManage.mark[row]))
                }
            }

            if score > 0 && labelScore5.intValue > score{
                labelScore5.intValue = Int32(score)
            }
            if labelScore6.intValue < score {
                labelScore6.intValue = Int32(score)
            }
 
        }
        
        if lotoManage.quickPick == Array<Int>(repeating: on,count:5) {
            for colum in 0...carMatrix.cells.count  - 1{
                carMatrix.cells[colum].image = NSImage(named: "")
            }
            carMatrix.cells[carMatrix.cells.count - 1].image = NSImage(named: "car2")
            labelCount.stringValue = separateComma(num: lotoManage.counter) + "m"
            timer.invalidate()
        }
        if lotoManage.drivingMode == km.drive.rawValue{
            var _ = drivingCar()
        }
    }
    //  検索エンジン
    func searchEngine(inDt: [Int]) -> [Int]{
        let validationNumber = inDt
        var judgment = Array<Int>(repeating: off,count:6)
        
        //A よく出る数字（完全一致）
        numberIn = 0
        numberMatch = 0
        for column in 0...lotoManage.markOfloto - 1{
            if lotoManage.selectionNumber[column] > 0{
                numberIn += 1
            }
            for cell in 0...lotoManage.markOfloto - 1{
                if validationNumber[column] == lotoManage.selectionNumber[cell]{
                    numberMatch += 1
                }
            }
        }
        if numberIn == numberMatch{
            judgment[0] += 1
            lotoManage.hitRezult[0] += 1
        }
        //B  除外
        var reject = 0
        for cell in 0...lotoManage.rejectedNumber.count - 1{
            for column in 0...lotoManage.markOfloto - 1{
                if  validationNumber[column] == lotoManage.rejectedNumber[cell]{
                    reject += 1
                }
            }
        }
        if reject == 0 {
            lotoManage.hitRezult[1] += 1
            judgment[1] += 1
        }
        //C  連続した数字
        for column in 0...lotoManage.markOfloto - 2{
            if validationNumber[column] + 1 == validationNumber[column + 1]{
                judgment[2] += 1
                lotoManage.hitRezult[2] += 1
            }
        }
        //D 下一桁
        var overlap = 0
        var lastSingleDigit: Array = Array<Int>()
        for cell in validationNumber {
            let singleDigit = cell % 10
            lastSingleDigit.append(singleDigit)
        }
        for cell  in 0...lastSingleDigit.count - 2{
            if lastSingleDigit[cell] == lastSingleDigit[cell + 1] {
                overlap += 1
            }
        }
        if overlap == 1 {
            judgment[3] += 1
            lotoManage.hitRezult[3] += 1
        }
        //   指定番号
        for  colum in 0...lotoManage.group[lotoManage.category].count - 1{
            if lotoManage.counter == lotoManage.group[lotoManage.category][colum]{
                judgment[4] += 1
            }
        }
        
        //F  カラー
        var colorBox: Array<Int> = Array<Int>(repeating: 0,count:7)
        for column in 0...lotoManage.markOfloto - 1 {
            let point:Int = validationNumber[column] % colorBox.count
            colorBox[point] += 1
        }
    
        if colorBox[lotoManage.color[lotoManage.category]] > 2 {
            judgment[5] += 1
        }
        
        //  評価せず
        for row in 0...lotoManage.conditionsSet[0].count - 1{
            if  lotoManage.conditionsSet[lotoManage.category][row] == off{
                judgment[row] += 1
            }
        }
        for cell in 0...lotoManage.conditionsSet[0].count - 1{
            if judgment[cell] > 0 {
                judgment[cell] = on
            }
        }
        return judgment
    }
    
    @IBAction func category(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
    
        lotoManage.category = matrix.selectedRow
        UserDefaults.standard.set(lotoManage.category, forKey: "intCategory")
        var _ = size(inDt: lotoManage.category)
        if lotoManage.category == 0 || lotoManage.category == 1{
            for row in 0...4{
                for cell in lotoManage.markOfloto...6{
                    let seq = row * 7 + cell
                    markBallMatrix.cells[seq].title = ""
                    markBallMatrix.cells[seq].image =  NSImage(named: "")
                }
            }
        }
        for row in 0...lotoManage.conditionsSet[0].count - 1{
            checkBoxMatrix.cells[row].doubleValue = Double(lotoManage.conditionsSet[lotoManage.category][row])
        }
        
        for cell in 0...2 {
             groupMatrix.cells[cell].stringValue = String(lotoManage.group[lotoManage.category][cell])
        }
        let color: String = "ball" + String(lotoManage.color[lotoManage.category])
        colorButton.image =  NSImage(named: color)
        if lotoManage.color[lotoManage.category] == 0 {
            colorButton.title = "7"
        } else {
            colorButton.title = String(lotoManage.color[lotoManage.category])
        }
        lotoManage.lastWinNumber = Array<Int>(repeating: 0,count:7)
        for cell in 0...lotoManage.lastWinNumber.count - 1{
            lastWinMatrix.cells[cell].stringValue = transfromFromZeroToBlank(inDt: lotoManage.lastWinNumber[cell])
        }
        lotoManage.selectionNumber = Array<Int>(repeating: 0,count:7)
        var _ = selectionNumberSet()
        for cell in 0...lotoManage.selectionNumber.count - 1{
            selectionMatrix.cells[cell].stringValue = transfromFromZeroToBlank(inDt: lotoManage.selectionNumber[cell])
        }
        lotoManage.rejectedNumber = Array<Int>(repeating: 0,count:7)
        for cell in 0...lotoManage.rejectedNumber.count - 1{
            rejectionMatrix.cells[cell].stringValue = transfromFromZeroToBlank(inDt: lotoManage.rejectedNumber[cell])
        }
        lotoManage.layer =  [[Int]](repeating: [Int](repeating: 0, count: 43),count: 2)
        lotoManage.keyboardMode = dm.normal.rawValue
        var _ = lotoManage.initializeKeyboard()
        var _ = changeTheKeyPad()
        
        
    }
    
    @IBAction func rakuten(_ sender: Any) {
        DispatchQueue.global().async {
            self.display() {
                // 別スレッドが終わったらこのクロージャが呼ばれる
                // 描画にかかわりのある処理はメインスレッド上で実行しなければならない
                DispatchQueue.main.async {
                    // 有効に戻す
                    // control?.isEnable = true
                }
            }
        }
        
        var _ = setMaskNumber()
    }
    
    private func display(_ completionHandler: () -> Void) {
        timer.invalidate()
        //  beforeDistribution
        lotoManage.rakutenData.removeAll()
        lotoManage.rakutenData = rakutenLotoSite(yyyymm: "")
        DispatchQueue.main.async { self.kaigo.stringValue = "第" + String(lotoManage.rakutenData[0][0] + 1) + "回" }
        lotoManage.kaigo = lotoManage.rakutenData[0][0] + 1

        let yy = lotoManage.rakutenData[0][1] / 10000
        let mmdd = lotoManage.rakutenData[0][1] % 10000
        let mm = mmdd  / 100
        let numberOfMonths = yy * 12 + mm
        var keyYY = (numberOfMonths - 1) / 12
        var keyMM = (numberOfMonths - 1) % 12
        if keyMM == 0{
            keyYY -= 1
            keyMM = 12
        }
        lotoManage.backPosition = keyYY * 100 + keyMM
        for i in 0...10{        //  11ヶ月分
            DispatchQueue.main.async { self.progressBar.doubleValue = Double(i + 1) / 11 }
            let yy = lotoManage.backPosition / 100
            let mm = lotoManage.backPosition % 100
            let numberOfMonths = yy * 12 + mm
            var keyYY = (numberOfMonths - i) / 12
            var keyMM = (numberOfMonths - i) % 12
            if keyMM == 0{
                keyYY -= 1
                keyMM = 12
            }
            let key = String(keyYY * 100 + keyMM)
            
            let temp = rakutenLotoSite(yyyymm: key)
            for i in 0...temp.count - 1{
                lotoManage.rakutenData.append(temp[i])
            }
        }
        for cell in 0...lotoManage.lastWinNumber.count - 1{
            lotoManage.lastWinNumber[cell] = 0
            if cell < lotoManage.rakutenData[0].count - 2 {
                lotoManage.lastWinNumber[cell] = lotoManage.rakutenData[0][cell + 2]
            }
        }
        lotoManage.overalls[lotoManage.category] = lotoManage.rakutenData.count - 1 // 前回データ除く。
        DispatchQueue.main.async { self.overallsMatrix.cells[lotoManage.category].intValue = Int32(lotoManage.overalls[lotoManage.category]) }
        UserDefaults.standard.set(lotoManage.overalls, forKey: "overallsArray")
        
        if lotoManage.recently[lotoManage.category] > lotoManage.overalls[lotoManage.category] {
            lotoManage.recently[lotoManage.category] = lotoManage.overalls[lotoManage.category]
            DispatchQueue.main.async { self.recentlyMatrix.cells[lotoManage.category].intValue = Int32(lotoManage.recently[lotoManage.category]) }
            UserDefaults.standard.set(lotoManage.recently, forKey: "recentlyArray")
        }
    
        //  distribution
        lotoManage.distribution = [[Int]](repeating: [Int](repeating: 0, count: 3),count: 43)
        var mark = 0
        switch lotoManage.category {
        case lm.miniloto.rawValue: mark = markOfMini
        case lm.loto6.rawValue: mark = markOfLoto6
        case lm.loto7.rawValue: mark = markOfLoto7
        default:
            print("error")
        }
        for cell in 0...lotoManage.sizeOfloto - 1{
            lotoManage.distribution[cell][0] = cell
        }
        
        if lotoManage.overalls[lotoManage.category] > 0 {
             for i in 1...lotoManage.overalls[lotoManage.category]{  //全部 但し、前回データ除く。
                for j in 2...mark + 1{
                    lotoManage.distribution[lotoManage.rakutenData[i][j] - 1][1] += 1
                }
            }
        }
        if lotoManage.recently[lotoManage.category] > 0 {
            for i in 1...lotoManage.recently[lotoManage.category]{   // 直近、但し、前回データ除く。
                for j in 2...mark + 1{
                    lotoManage.distribution[lotoManage.rakutenData[i][j] - 1][2] += 1
                }
            }
        }
        lotoManage.distribution.sort { $0[1] > $1[1] }
        UserDefaults.standard.set(lotoManage.rakutenData,forKey: "rakutenArray")
        UserDefaults.standard.set(lotoManage.distribution,forKey: "distributionArray")
        
        lotoView.max = lotoManage.distribution[0][1]
        DispatchQueue.main.async {
            for cell in 0...lotoManage.keyboard.count - 1{
                self.numericKeypadMatrix.cells[cell].title = ""
            }
            for cell in 0...lotoManage.sizeOfloto - 1{
                self.numericKeypadMatrix.cells[cell].title = String(lotoManage.keyboard[cell])
            }
            self.timer.invalidate()
            self.labelScore5.intValue = 999
            self.labelScore6.intValue = 1
            self.viewDidLoad()
        }
        //  前回当せん番号
        DispatchQueue.main.async {
            for cell in 0...lotoManage.lastWinNumber.count - 1{
                self.lastWinMatrix.cells[cell].stringValue = ""
            }
            for cell in 0...lotoManage.markOfloto - 1{
                self.lastWinMatrix.cells[cell].stringValue = transfromFromZeroToKome(inDt: lotoManage.lastWinNumber[cell])
            }
            if lotoManage.lastWinNumber != Array<Int>(repeating: 0,count:7){
                self.average.stringValue = String(format: "%.1f",self.average(inDt:lotoManage.lastWinNumber))
            }
        }
        
        timer.fire()
        // 処理が終わったら与えられた関数を実行する
        completionHandler()
    }
    
    @IBAction func keyPadAction(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        let row = matrix.selectedRow
        let colum = matrix.selectedColumn
        let push = row * 10 + colum
        
        if (push >= lotoManage.sizeOfloto && push < 46){
            audioPlayer?.play()
            return
        }
        
        //  MARK:マークを外す
        if push < lotoManage.sizeOfloto {
            switch lotoManage.tab {
            case off:
                for cell in 0...lotoManage.selectionNumber.count - 1{
                    if  lotoManage.selectionNumber[cell] == lotoManage.keyboard[push]{
                        lotoManage.selectionNumber[cell] = 0
                        numericKeypadMatrix.cells[push].image = NSImage(named: "NSStatusNone")
                        var _ = selectionNumberSet()
                        lotoManage.layer =  [[Int]](repeating: [Int](repeating: 0, count: 43),count: 2)
                        return
                    }
                }
            case on:
                for cell in 0...lotoManage.rejectedNumber.count - 1{
                    if lotoManage.rejectedNumber[cell] == lotoManage.keyboard[push] {
                        lotoManage.rejectedNumber[cell] = 0
                        numericKeypadMatrix.cells[push].image = NSImage(named: "NSStatusNone")
                        var _ = rejectedNumberSet()
                        lotoManage.layer =  [[Int]](repeating: [Int](repeating: 0, count: 43),count: 2)
                        return
                    }
                }
            default:
                print("error")
            }
            
        }
        //  MARK:マークする
        if push < lotoManage.sizeOfloto {
            switch lotoManage.tab {
                case off:
                    for i in 0...lotoManage.markOfloto - 1 {
                        if lotoManage.selectionNumber[i] == 0 {
                            lotoManage.selectionNumber[i] = lotoManage.keyboard[push]
                            var _ = setLayer(inDt: lotoManage.selectionNumber, layer: ly.redCircle.rawValue)
                            var _ = displayLayer()
                            break
                        }
                    }
                    var _ = selectionNumberSet()
                case on:
                    for i in 0...lotoManage.markOfloto - 1 {
                        if lotoManage.rejectedNumber[i] == 0 {
                            lotoManage.rejectedNumber[i] = lotoManage.keyboard[push]
                            var _ = setLayer(inDt: lotoManage.rejectedNumber, layer: ly.redBollot.rawValue)
                            var _ = displayLayer()
                            break
                        }
                    }
                    var _ = rejectedNumberSet()
                default:
                    print("error")
                }
        }
        //MARK:マイナンバー、除外する数字のタブ
        if push == 46{
            lotoManage.tab += 1
            lotoManage.tab = lotoManage.tab % 2
            switch lotoManage.tab {
            case 0:
                numericKeypadMatrix.cells[46].image = NSImage(named: "redPencil")
            case 1:
                numericKeypadMatrix.cells[46].image = NSImage(named: "blackPencil")
            default:
                print("error")
            }
        }
        //  MARK:グラフ描画
        if push == 47{
            guard lotoManage.kaigo > 0 else {
                audioPlayer?.play()
                return
            }
            guard lotoManage.rakutenData[0].count == lotoManage.markOfloto + 3 else {
                audioPlayer?.play()
                return
            }
            lotoManage.graphdraw += 1
            lotoManage.graphdraw = lotoManage.graphdraw % 2
            switch lotoManage.graphdraw {
            case 0:
                lotoView.goDraw = ld.erase
                timer.invalidate()
                var _ = loadView()
                let storeConditionsSet = lotoManage.conditionsSet[lotoManage.category]  //待避
                let storeRejectedNumber = lotoManage.rejectedNumber
                lotoManage.conditionsSet[lotoManage.category] = Array<Int>(repeating: 1,count:6)
                lotoManage.page = 1
                var _ = chanceRecord(inDt: lotoManage.page)
                lotoManage.conditionsSet[lotoManage.category] = storeConditionsSet  //  復帰
                lotoManage.rejectedNumber = storeRejectedNumber
            case 1:
                for backNumber in 0...15{
                    for cell in 0...9{
                        winMairix.cell(atRow: (backNumber), column: cell)?.stringValue = ""
                    }
                }
                var _ = graphDrawing()
            default:
                print("error")
            }
            var _ = displayLayer()
        }
        //  MARK:マスククリア
        if push == 48{
            lotoManage.selectionNumber = Array<Int>(repeating: 0,count:7)
            var _ = selectionNumberSet()
            lotoManage.rejectedNumber = Array<Int>(repeating: 0,count:7)
            var _ = rejectedNumberSet()
            lotoManage.layer = [[Int]](repeating: [Int](repeating: 0, count: 43),count: 2)
            var _ = changeTheKeyPad()
        }
        //  MARK:キーボード切り替え
        if push == 49 {
            guard lotoManage.kaigo > 0 else {
                audioPlayer?.play()
                return
            }
            guard lotoManage.rakutenData[0].count == lotoManage.markOfloto + 3 else {
                audioPlayer?.play()
                return
            }
            switch lotoManage.keyboardMode {
            case dm.normal.rawValue:
                lotoManage.keyboardMode = dm.frequentNumbers.rawValue
                lotoManage.frequentlyKeyboard()
                var _ = changeTheKeyPad()
            case dm.frequentNumbers.rawValue:
                lotoManage.keyboardMode = dm.normal.rawValue
                var _ = lotoManage.initializeKeyboard()
                var _ = changeTheKeyPad()
            default:
                print("error")
            }
            var _ = displayLayer()
        }
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        lotoManage.slider = mySlider.integerValue
        textSpeed.stringValue = "\(mySlider.integerValue) %"
        let a: Double = Double((100 - mySlider.integerValue))
        lotoManage.cpuTimeInterval = a * 0.1
        UserDefaults.standard.set(lotoManage.slider, forKey: "slider")
        UserDefaults.standard.set(lotoManage.cpuTimeInterval, forKey: "cpuTimeInterval")
     
        timer.invalidate()
        lotoManage.distribution.sort { $0[0] < $1[0] }
        timer = Timer.scheduledTimer(timeInterval: lotoManage.cpuTimeInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()
    
    }
    
    @IBAction func drivingModeSet(_ sender: Any) {
        lotoManage.drivingMode += 1
        lotoManage.drivingMode = lotoManage.drivingMode % 2
        timer.invalidate()
        hittitle.stringValue = ""
        Kilometers = -1
        labelCount.stringValue = ""
        lotoManage.quickPick =  Array<Int>(repeating: off,count:5)
        for row in 0...4{
            var _ = blackMark(inDt:row)
        }
        lotoManage.hitRezult = Array<Int>(repeating: 0,count:6)
        for cell in 0...lotoManage.hitRezult.count - 1 {
            hitMatrix.cells[cell].stringValue = transfromFromZeroToBlank(inDt: lotoManage.hitRezult[cell])
        }
        for row in 0...4{
            quickPickMatrix.cells[row].title =  "クイックピック"
        }
        if lotoManage.drivingMode == off {
            
            drivingModeBUtton.title = "idling"
            nextQuickLabel.stringValue = ""
            lotoManage.layer[0] = Array<Int>(repeating: 0,count:43)
            var _ = displayLayer()
            lotoManage.distribution.sort { $0[0] < $1[0] }
            for colum in 0...carMatrix.cells.count  - 1{
                carMatrix.cells[colum].image = NSImage(named: "")
            }
            timer = Timer.scheduledTimer(timeInterval: lotoManage.cpuTimeInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            timer.fire()
        }
        if lotoManage.drivingMode == on {
            drivingModeBUtton.title = "automatic drive"
            lotoManage.mark =  [[Int]](repeating: [Int](repeating: 0, count: 7),count: 5)
            for row in 0...4{
                var _ = setShuffleNumber(inDt:row)
                var _ = blackMark(inDt:row)
            }
            lotoManage.counter = 0
            let max :Double = 0.0001
            timer = Timer.scheduledTimer(timeInterval: max, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    
    
    @IBAction func quickPick(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        let row = matrix.selectedRow
        lotoManage.quickPick[row] += 1
        lotoManage.quickPick[row] =  lotoManage.quickPick[row]  % 2
        
        switch lotoManage.drivingMode {
        case km.idling.rawValue:
            if lotoManage.quickPick[row] == off{
                quickPickMatrix.cells[row].title = "クイックピック"
            }
            if lotoManage.quickPick[row] == on{
                quickPickMatrix.cells[row].title = "選択中"
            }
        case km.drive.rawValue:
            for cell in 0...4{
                quickPickMatrix.cells[cell].title = "クイックピック"
            }
            quickPickMatrix.cells[row].title = "選択中"
        default:
            print("error")
        }
        nextQuick = row
        lotoManage.layer[0] = Array<Int>(repeating: 0,count:43)
        var _ = setLayer(inDt: lotoManage.mark[row], layer: ly.redCircle.rawValue)
        var _ = changeTheKeyPad()
        var _ = displayLayer()
    }
    
    @IBAction func group(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        let colum = matrix.selectedColumn
        lotoManage.group[lotoManage.category][colum] = Int(groupMatrix.cells[colum].intValue)
        UserDefaults.standard.set(lotoManage.group, forKey: "groupArray")
        
    }
    
    @IBAction func color(_ sender: Any) {
       
        lotoManage.color[lotoManage.category] += 1
        lotoManage.color[lotoManage.category] = lotoManage.color[lotoManage.category] % 7
        let color: String = "ball" + String(lotoManage.color[lotoManage.category])
        colorButton.image =  NSImage(named: color)
        if lotoManage.color[lotoManage.category] == 0 {
            colorButton.title = "7"
        } else {
            colorButton.title = String(lotoManage.color[lotoManage.category])
        }
        UserDefaults.standard.set(lotoManage.color,forKey: "colorArray")
    }
    
    
    @IBAction func recently(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        let row = matrix.selectedRow
        
        lotoManage.recently[row] = Int(recentlyMatrix.cells[row].intValue)
        if lotoManage.recently[row] == 0 {
            lotoManage.recently[row] = 12
        }
        if lotoManage.recently[row] > lotoManage.overalls[row]{
            lotoManage.recently[row] = lotoManage.overalls[row]
        }
        recentlyMatrix.cells[row].intValue = Int32(lotoManage.recently[row])
        UserDefaults.standard.set(lotoManage.recently, forKey: "recentlyArray")
    }
    
    @IBAction func scoreCheck(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        let row = matrix.selectedRow
        
        lotoManage.score[row] = Int(scoreCheckMatrix.cells[row].intValue)
        UserDefaults.standard.set(lotoManage.score, forKey: "scoreArray")
    }
    
    @IBAction func stamp(_ sender: Any) {
        for cell in 0...lotoManage.selectionNumber.count - 1{
            selectionMatrix.cells[cell].stringValue = ""
        }
        for cell in 0...lotoManage.markOfloto - 1{
            selectionMatrix.cells[cell].stringValue = "※"
        }
        lotoManage.selectionNumber = Array<Int>(repeating: 0,count:7)
        
        let tag = Int((sender as AnyObject).tag)
        for cell in 0...lotoManage.markOfloto - 1{
            if  lotoManage.myNumber[lotoManage.category][tag][cell] > 0 {
                lotoManage.selectionNumber[cell] = lotoManage.myNumber[lotoManage.category][tag][cell]
                selectionMatrix.cells[cell].intValue = Int32(lotoManage.selectionNumber[cell])
            }
        }
        lotoManage.layer[0] = Array<Int>(repeating: 0,count:43)
        var _ = changeTheKeyPad()
        var _ = setLayer(inDt: lotoManage.myNumber[lotoManage.category][Int((sender as AnyObject).tag)], layer: ly.redCircle.rawValue)
        var _ = displayLayer()
    }

    @IBAction func excludedNumbers(_ sender: Any) {
        guard lotoManage.kaigo > 0 else {
            audioPlayer?.play()
            return
        }
        
        lotoManage.conditionsSet[lotoManage.category][1] = on
        checkBoxMatrix.cells[1].doubleValue = 1.0
        lotoManage.rejectedNumber = lotoManage.lastWinNumber
        for cell in 0...lotoManage.rejectedNumber.count - 1{
            rejectionMatrix.cells[cell].stringValue = transfromFromZeroToBlank(inDt: lotoManage.rejectedNumber[cell])
        }
        var _ = setLayer(inDt: lotoManage.rejectedNumber, layer: ly.redBollot.rawValue)
        var _ = displayLayer()
        numericKeypadMatrix.cells[46].image = NSImage(named: "blackPencil")
        lotoManage.tab = on
    }
    
    @IBAction func SetMyStamp(_ sender: Any) {
        lotoManage.popUpButton = Int(popUpButton.indexOfSelectedItem)
        for cell in 0...lotoManage.markOfloto - 1{
            lotoManage.myNumber[lotoManage.category][lotoManage.popUpButton][cell] = lotoManage.selectionNumber[cell]
        }
        var _ = setMaskNumber()
        UserDefaults.standard.set(lotoManage.myNumber,forKey: "myNUmberArray")
    }
    
    @IBAction func conditionsSet(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        guard let cell = matrix.selectedCell() else {
            return
        }
        let row = matrix.selectedRow
        lotoManage.conditionsSet[lotoManage.category][row] = Int(cell.doubleValue)
        if row == 0 {
            lotoManage.selectionNumber = Array<Int>(repeating: 0,count:7)
            lotoManage.layer[0] = Array<Int>(repeating: 0,count:43)
            for cell in 0...lotoManage.selectionNumber.count - 1{
                selectionMatrix.cells[cell].stringValue = ""
            }
            if  Int(cell.doubleValue) == on{
                lotoManage.tab = off
            }
        }
        if row == 1 {
            lotoManage.rejectedNumber = Array<Int>(repeating: 0,count:7)
            lotoManage.layer[1] = Array<Int>(repeating: 0,count:43)
            for cell in 0...lotoManage.rejectedNumber.count - 1{
                rejectionMatrix.cells[cell].stringValue = ""
            }
            if  Int(cell.doubleValue) == on{
                lotoManage.tab = on
            }
        }
        UserDefaults.standard.set(lotoManage.conditionsSet,forKey: "conditionsArray")
    }
    
    @IBAction func graphCategory(_ sender: Any) {
        guard let matrix = sender as? NSMatrix else {
            return
        }
        lotoManage.graphCategory = matrix.selectedColumn
    }
    
    func setAudio(){
        audioName = "decision1"
        let setURL = Bundle.main.url(forResource: audioName,withExtension: "mp3")
        
        if let selectURL = setURL{
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: selectURL, fileTypeHint: nil)
            }catch{
                print("ERROR")
            }
        }
    }
    
    @objc func drivingCar() {
        let date = Date()
        let calendar = Calendar.current
        var second = calendar.component(.second, from: date)
        second = second / 3
        
        if beforeSecond != second{
            let numberOfframes = carMatrix.cells.count
            Kilometers += 1
            let cell = Kilometers % numberOfframes
            for colum in 0...carMatrix.cells.count  - 1{
                carMatrix.cells[colum].image = NSImage(named: "")
            }
            if lotoManage.quickPick != Array<Int>(repeating: on,count:5) {
                switch cell {
                    case 0:
                        carMatrix.cells[numberOfframes - cell - 1].image = NSImage(named: "car2")
                    case 1...(numberOfframes - 1):
                        carMatrix.cells[numberOfframes - cell - 1].image = NSImage(named: "car1")
                        if lotoManage.cpuTimeInterval == 0.00001{
                            carMatrix.cells[numberOfframes - cell - 1].image = NSImage(named: "car3")
                        }
                        labelCount.stringValue = separateComma(num: lotoManage.counter) + "m"
                    default:
                        print("error")
                }
            }
            beforeSecond = second
        }
    }
    //  MARK: 　リストア（ユーザーデフォルト)
    func defaultsLoad() {
        let userDefaults = UserDefaults.standard
        
        if (userDefaults.object(forKey: "intCategory") != nil) {
            lotoManage.category = UserDefaults.standard.integer(forKey: "intCategory")
        }
        var _ = size(inDt: lotoManage.category)
        if (userDefaults.object(forKey: "conditionsArray") != nil) {
            lotoManage.conditionsSet =  userDefaults.array(forKey: "conditionsArray")  as! [[Int]]
            for row in 0...lotoManage.conditionsSet[0].count - 1{
                checkBoxMatrix.cells[row].doubleValue = Double(lotoManage.conditionsSet[lotoManage.category][row])
            }
        }
        if (userDefaults.object(forKey: "myNUmberArray") != nil) {
            lotoManage.myNumber = userDefaults.array(forKey: "myNUmberArray") as! [[[Int]]]
            var _ = setMaskNumber()
        }
        if (userDefaults.object(forKey: "rakutenArray") != nil) {
            lotoManage.rakutenData = userDefaults.array(forKey: "rakutenArray") as! [[Int]]
        }
        if (userDefaults.object(forKey: "distributionArray") != nil) {
            lotoManage.distribution = userDefaults.array(forKey: "distributionArray") as! [[Int]]
        }
        
        if (userDefaults.object(forKey: "groupArray") != nil) {
            lotoManage.group = userDefaults.array(forKey: "groupArray") as! [[Int]]
            for colum in 0...lotoManage.group[0].count - 1{
                groupMatrix.cells[colum].stringValue = String(lotoManage.group[lotoManage.category][colum])
            }
        }else{
            for colum in 0...lotoManage.group[0].count - 1{
                groupMatrix.cells[colum].stringValue = String(lotoManage.group[lotoManage.category][colum])
            }
        }
        
        if (userDefaults.object(forKey: "colorArray") != nil) {
            lotoManage.color =  userDefaults.array(forKey: "colorArray")  as! Array<Int>
            let color: String = "ball" + String(lotoManage.color[lotoManage.category])
            colorButton.image =  NSImage(named: color)
            if lotoManage.color[lotoManage.category] == 0 {
                colorButton.title = "7"
            } else {
                colorButton.title = String(lotoManage.color[lotoManage.category])
            }
        }
  
        if (userDefaults.object(forKey: "overallsArray") != nil) {
            lotoManage.overalls =  userDefaults.array(forKey: "overallsArray")  as! Array<Int>
            for cell in 0...lotoManage.overalls.count - 1{
                overallsMatrix.cells[cell].intValue = Int32(lotoManage.overalls[cell])
            }
        }
        if (userDefaults.object(forKey: "recentlyArray") != nil) {
            lotoManage.recently =  userDefaults.array(forKey: "recentlyArray")  as! Array<Int>
            for cell in 0...lotoManage.recently.count - 1{
                recentlyMatrix.cells[cell].intValue = Int32(lotoManage.recently[cell])
            }
        }
        if (userDefaults.object(forKey: "scoreArray") != nil) {
            lotoManage.score =  userDefaults.array(forKey: "scoreArray")  as! Array<Int>
            for cell in 0...lotoManage.score.count - 1{
                scoreCheckMatrix.cells[cell].intValue = Int32(lotoManage.score[cell])
            }
        }
        if (userDefaults.object(forKey: "slider") != nil) {
            lotoManage.slider = userDefaults.integer(forKey: "slider")
            mySlider.doubleValue = Double(lotoManage.slider)
            textSpeed.stringValue = "\(mySlider.integerValue) %"
        }
        if (userDefaults.object(forKey: "cpuTimeInterval") != nil) {
            lotoManage.cpuTimeInterval = Double(UserDefaults.standard.double(forKey: "cpuTimeInterval"))
        }
        radioButton.setState(1, atRow: lotoManage.category, column: 0)
        for cell in 0...lotoManage.markOfloto - 1{
            selectionMatrix.cells[cell].stringValue = transfromFromZeroToKome(inDt: lotoManage.selectionNumber[cell])
        }
        for cell in 0...lotoManage.markOfloto - 1{
            rejectionMatrix.cells[cell].stringValue = transfromFromZeroToKome(inDt: lotoManage.rejectedNumber[cell])
        }
        
        let ave: Array<Double> = [0.8064,0.8333,1.3288]
        mediumValue.stringValue = "mediumValue..." + String(Int(ave[lotoManage.category] * Double(lotoManage.recently[lotoManage.category]) + 0.5))

    }
    
    func graphDrawing() -> Void {
        guard lotoManage.kaigo > 0 else {
         lotoManage.graphdraw += 1
         lotoManage.graphdraw = lotoManage.graphdraw % 2
            return
        }
        
        for backNumber in 0...15{
            for cell in 0...9{
                winMairix.cell(atRow: (backNumber), column: cell)?.stringValue = ""
            }
        }
        timer.invalidate()
        switch lotoManage.graphCategory {
        case gc.barChart.rawValue:
            lotoView.goDraw = ld.goDrawBarChart
        case gc.dotChart.rawValue:
            lotoView.goDraw = ld.goDrawDotChart
        default:
            print("error")
        }
        var _ = loadView()
        var sample = 0
        for cell in 0...sizeOfLoto6 - 1{
            sample += lotoManage.distribution[cell][1]
        }
        
        if lotoManage.graphCategory == gc.barChart.rawValue{
            lableNear.stringValue = ""
            labelMax.intValue = Int32(lotoView.max)
            let remainder = lotoView.max % 2
            if remainder == 0{
                labelMiddle.intValue = Int32(lotoView.max / 2)
            }
            if remainder == 1{
                labelMiddle.stringValue = String(lotoView.max / 2) + ".5"
            }
            for cell in 0...7{
                let tickMark:Int = (cell + 1) * 5
                scaaleMatrix.cells[cell].intValue = Int32(tickMark)
            }
        }
            
        if lotoManage.graphCategory == gc.dotChart.rawValue{
            lableNear.stringValue = "第" + String(lotoManage.rakutenData[0][0]) + "回"
            labelMiddle.stringValue = "第" + String(lotoManage.rakutenData[19][0]) + "回"
            for cell in 0...7{
                let tickMark:Int = (cell + 1) * 5
                scaaleMatrix.cells[cell].intValue = Int32(tickMark)
            }
        }
    }
    
    @IBAction func page(_ sender: Any) {
        let rowSize = 15
        var pageMax = lotoManage.rakutenData.count  / rowSize +  1
        if lotoManage.rakutenData.count % rowSize == 0{
            pageMax = pageMax - 1
        }
        
        lotoManage.page += 1
        if lotoManage.page  > pageMax {
            lotoManage.page = 1
        }
        let store = lotoManage.conditionsSet[lotoManage.category]  //待避
        let storeRejectedNumber = lotoManage.rejectedNumber
        lotoManage.conditionsSet[lotoManage.category] = Array<Int>(repeating: 1,count:6)
        var _ = chanceRecord(inDt: lotoManage.page)
        lotoManage.conditionsSet[lotoManage.category] = store   //  復帰
        lotoManage.rejectedNumber = storeRejectedNumber
    }
    
    func chanceRecord(inDt: Int) -> Void {
        guard lotoManage.kaigo > 0 else {
            lotoManage.graphdraw += 1
            lotoManage.graphdraw = lotoManage.graphdraw % 2
            return
        }
        let rowSize = 15
        let iroha:Array = ["A","B","C","D","E","F"]
        labelMax.stringValue = ""
        labelMiddle.stringValue = ""
        lableNear.stringValue = ""
        for backNumber in 0...rowSize - 1{
            for cell in 0...9{
                winMairix.cell(atRow: (backNumber), column: cell)?.stringValue = ""
            }
        }
        
        for row in 0...rowSize - 1 {
            let backNumber = (inDt - 1) * rowSize + row
            guard backNumber < lotoManage.rakutenData.count else {
                return
            }
            var dt:[String] = Array<String>(repeating: "",count:10)
            dt[0] = "第"
            dt[1] = String(lotoManage.rakutenData[backNumber][0]) + " 回"
            
            var dt2 = ""
            var temp = Array<Int>()
            for cell in 0...lotoManage.markOfloto - 1 {
                temp.append(lotoManage.rakutenData[backNumber][cell + 2])
            }
           
            for cell in 0...lotoManage.markOfloto - 1{
                if backNumber < lotoManage.rakutenData.count - 1{
                    lotoManage.rejectedNumber[cell] = lotoManage.rakutenData[backNumber + 1][cell + 2]
                }
            }
            
            let judgment:Array = searchEngine(inDt: temp)
            
            for cell in 0...5 {
                if judgment[cell] == on{
                    dt2 = dt2 + iroha[cell]
                }
            }
            dt[2] = dt2
            for cell in 0...lotoManage.markOfloto - 1 {
                dt[cell + 3] = String(lotoManage.rakutenData[backNumber][cell + 2])
            }
            for cell in 0...lotoManage.markOfloto + 2{
                winMairix.cell(atRow: row, column: cell)?.stringValue = dt[cell]
            }
        }
    }
    
    //  レイヤー
    func setLayer(inDt: [Int],layer: Int) -> Void{
        for cell in 0...inDt.count - 1{
            if inDt[cell] > 0 {
                switch lotoManage.keyboardMode {
                case dm.normal.rawValue:
                    lotoManage.layer[layer][inDt[cell] - 1] = on
                case dm.frequentNumbers.rawValue:
                    for key in 0...lotoManage.sizeOfloto - 1{
                        if inDt[cell] == lotoManage.keyboard[key]{
                            lotoManage.layer[layer][lotoManage.keyboard[key] - 1] = on
                        }
                    }
                default:
                    print("error")
                }
            }
        }
    }
    //  レイヤー表示
    func displayLayer() {
        
        switch lotoManage.keyboardMode {
        case dm.normal.rawValue:
            for key in 0...lotoManage.sizeOfloto - 1{
                if lotoManage.layer[ly.redBollot.rawValue][key] == on{
                    numericKeypadMatrix.cells[key].image = NSImage(named: "blackBollot")
                    numericKeypadMatrix.cells[key].title = String(lotoManage.keyboard[key])
                }
            }
            for key in 0...lotoManage.sizeOfloto - 1{
                if lotoManage.layer[ly.redCircle.rawValue][key] == on{
                    numericKeypadMatrix.cells[key].image = NSImage(named: "redCircle")
                    numericKeypadMatrix.cells[key].title = String(lotoManage.keyboard[key])
                }
            }
        case dm.frequentNumbers.rawValue:
            for layer in 0...lotoManage.sizeOfloto - 1{
                if lotoManage.layer[ly.redBollot.rawValue][layer] == on{
                    let no = layer + 1
                    for key in 0...lotoManage.sizeOfloto - 1{
                        if lotoManage.keyboard[key] == no{
                            for cell in 0...lotoManage.sizeOfloto - 1{
                                if no == lotoManage.keyboard[cell]{
                                    numericKeypadMatrix.cells[cell].image = NSImage(named: "blackBollot")
                                    numericKeypadMatrix.cells[cell].title = String(lotoManage.keyboard[cell])
                                }
                            }
                        }
                    }
                }
            }
            for layer in 0...lotoManage.sizeOfloto - 1{
                if lotoManage.layer[ly.redCircle.rawValue][layer] == on{
                    let no = layer + 1
                    for key in 0...lotoManage.sizeOfloto - 1{
                        if lotoManage.keyboard[key] == no{
                            for cell in 0...lotoManage.sizeOfloto - 1{
                                if no == lotoManage.keyboard[cell]{
                                    numericKeypadMatrix.cells[cell].image = NSImage(named: "redCircle")
                                    numericKeypadMatrix.cells[cell].title = String(lotoManage.keyboard[cell])
                                }
                            }
                        }
                    }
                }
            }
        default:
            print("error")
        }
    }
    //  アヴェレージの計算
    func average(inDt: [Int]) -> Double{
        var total: Double = 0.0
        for cell in 0...lotoManage.markOfloto - 1{
            for key in 0...lotoManage.sizeOfloto - 1{
                if  inDt[cell] == lotoManage.keyboard[key]{
                    total = total + Double(key) + 1
                }
            }
        }
        return Double(lotoManage.sizeOfloto) / 2.0 - total / Double(lotoManage.markOfloto)
    }
    // MARK: categoryからサイズ及びマークをセットする
    func size(inDt: Int){
        switch inDt {
        case 0:
            lotoManage.sizeOfloto = sizeOfMini
            lotoManage.markOfloto = markOfMini
        case 1:
            lotoManage.sizeOfloto = sizeOfLoto6
            lotoManage.markOfloto = markOfLoto6
        case 2:
            lotoManage.sizeOfloto = sizeOfLoto7
            lotoManage.markOfloto = markOfLoto7
        default:
            print("error")
        }
        
    }
    //  MARK:よくでた数字の編集
    func setMaskNumber() {
        for cell in 0...3{
            if lotoManage.myNumber[lotoManage.category][cell] != Array<Int>(repeating: off,count:7){
                var str = String(lotoManage.myNumber[lotoManage.category][cell][0])
                if lotoManage.myNumber[lotoManage.category][cell][1] > 0 {
                    str = str + "." + String(lotoManage.myNumber[lotoManage.category][cell][1])
                }
                if lotoManage.myNumber[lotoManage.category][cell][2] > 0 {
                    str = str + "." + String(lotoManage.myNumber[lotoManage.category][cell][2])
                }
                if lotoManage.myNumber[lotoManage.category][cell][3] > 0 {
                    str = str + "." + String(lotoManage.myNumber[lotoManage.category][cell][3])
                }
                if lotoManage.myNumber[lotoManage.category][cell][4] > 0 {
                    str = str + "." + String(lotoManage.myNumber[lotoManage.category][cell][4])
                }
                if lotoManage.myNumber[lotoManage.category][cell][5] > 0 {
                    str = str + "." + String(lotoManage.myNumber[lotoManage.category][cell][5])
                }
                if lotoManage.myNumber[lotoManage.category][cell][6] > 0 {
                    str = str + "." + String(lotoManage.myNumber[lotoManage.category][cell][6])
                }
                kanaMatrix.cells[cell].stringValue = str
            }
        }
    }
    //  MARK: 選択中の文字を表示する
    func setQuickPick(inDt:Int){
        let row = inDt
        quickPickMatrix.cells[row].title = "選択中"
    }
    
    func setShuffleNumber(inDt:Int){
        let row = inDt
        for colum in 0...lotoManage.markOfloto - 1{
            let seq = markOfLoto7 * row + colum
            markBallMatrix.cells[seq].title = transfromFromZeroToBlank(inDt: lotoManage.mark[row][colum])
            if lotoManage.mark[row][colum] > 0{
                let color:String = "ball" + String(lotoManage.mark[row][colum] % 7)
                markBallMatrix.cells[seq].image =  NSImage(named: color)
            }else{
                markBallMatrix.cells[seq].image =  NSImage(named: "")
            }
        }
        
    }
    //  MARK:キーボード表示する
    func changeTheKeyPad() {
        for cell in 0...lotoManage.keyboard.count - 1{
            numericKeypadMatrix.cells[cell].title = ""
            numericKeypadMatrix.cells[cell].image = NSImage(named: "NSStatusNone")
        }
        for cell in 0...lotoManage.sizeOfloto - 1{
            numericKeypadMatrix.cells[cell].title = String(lotoManage.keyboard[cell])
        }
        var _ = setLayer(inDt: lotoManage.selectionNumber, layer: ly.redCircle.rawValue)
        var _ = setLayer(inDt: lotoManage.rejectedNumber, layer: ly.redBollot.rawValue)
    }
    //  MARK:マイナンバーを表示する
    func selectionNumberSet() {
        for cell in 0...lotoManage.markOfloto - 1{
            selectionMatrix.cells[cell].stringValue = transfromFromZeroToKome(inDt: lotoManage.selectionNumber[cell])
        }
    }
    //  MARK: 除外する数字を表示する
    func rejectedNumberSet() {
        for cell in 0...lotoManage.markOfloto - 1{
            rejectionMatrix.cells[cell].stringValue = transfromFromZeroToKome(inDt: lotoManage.rejectedNumber[cell])
        }
    }
    //  数字の表示色は黒
    func blackMark(inDt:Int){
        let row = inDt
        switch row {
        case 0: labelA.textColor =  NSColor.black
        case 1: labelB.textColor =  NSColor.black
        case 2: labelC.textColor =  NSColor.black
        case 3: labelD.textColor =  NSColor.black
        case 4: labelE.textColor =  NSColor.black
        default: print("error")
        }
    }
    //  [A][B][C][D][E]の表示色は赤
    func redMark(inDt:Int){
        let row = inDt
        switch row {
        case 0: labelA.textColor =  NSColor.red
        case 1: labelB.textColor =  NSColor.red
        case 2: labelC.textColor =  NSColor.red
        case 3: labelD.textColor =  NSColor.red
        case 4: labelE.textColor =  NSColor.red
        default: print("error")
        }
    }
    //  連続する数字の表示色はマゼンタ
    func magentaMark(inDt:Int){
        let row = inDt
        switch row {
        case 0: labelA.textColor =  NSColor.magenta
        case 1: labelB.textColor =  NSColor.magenta
        case 2: labelC.textColor =  NSColor.magenta
        case 3: labelD.textColor =  NSColor.magenta
        case 4: labelE.textColor =  NSColor.magenta
        default: print("error")
        }
    }
    
    @IBAction func sportsCar(_ sender: Any) {
         timer.invalidate()
        DispatchQueue.global().async {
            self.sportsCarDrive() {
                DispatchQueue.main.async {
                }
            }
        }
    }
    
    func sportsCarDrive(_ completionHandler: () -> Void)  {
        let uriageKingaku = 2_400_000_000
        let category = ["ミニロト","ロト６","ロト７"]
        let tankaConst:Array = [200,200,300]
        let uriagemaisu = uriageKingaku / tankaConst[lotoManage.category]
        let probability:Array = ["169,911","6,096,454","10,295,472"]
        let zantei = 7
        var ballSet = [Int]()
        var ballBox = [Int]()
        print("\(category[lotoManage.category]),  当選確率、\(probability[lotoManage.category])、試行回数、\(uriagemaisu)  暫定、\(zantei)回以上")
        DispatchQueue.main.async {self.labelCount.stringValue = "" }
        //  生成
        for _ in 0...uriagemaisu - 1{
            var ballSetInt = 0
            printTimeElapsedWhenRunningCode(title: "Shuffle lazy") {
                let lotoArray = Array(0...lotoManage.sizeOfloto - 1)
                ballSet = Array(LazyShuffledSequence(elements: lotoArray).prefix(lotoManage.markOfloto))
            }
            for cell in 0...lotoManage.markOfloto - 1{
                 ballSet[cell] += 1
            }
            ballSet.sort(by: {$0 < $1})
            ballSetInt = packBall(inDt:ballSet)
            ballBox.append(ballSetInt)
        }
        DispatchQueue.main.async {self.labelCount.stringValue = "draive step1" }
        //絞り
        ballBox.sort(by: {$0 < $1})
        ballBox.append(99999999999999)
        var outBox = [[Int]]() //  ballSet 出現回数
        var saveBallSet = ballBox[0]
        var numberOfoccurrences = 1
        for cell in 1...ballBox.count - 1 {
            if saveBallSet == ballBox[cell] {
                numberOfoccurrences += 1
                
            } else {
                let outSet = [numberOfoccurrences,saveBallSet]
                if numberOfoccurrences >= zantei {    //暫定絞り
                    outBox.append(outSet)
                }
                saveBallSet = ballBox[cell]
                numberOfoccurrences = 1
            }
        }
        DispatchQueue.main.async {self.labelCount.stringValue = "draive step2" }
        outBox.sort { $1[0] < $0[0] }
        var limit = 0
        var limitString = ""
        if outBox[0][0] != outBox[4][0]{
            limit = outBox[4][0]
            limitString = "end... limit " + String(limit) + " - " + String(outBox[0][0])
        } else {
            limit = outBox[0][0]
        }
        DispatchQueue.main.async {self.labelCount.stringValue = limitString }
        
        ballBox.removeAll()
        for cell in 0...outBox.count - 1{
            if outBox[cell][0] >= limit {
                ballBox.append(outBox[cell][1])
            }
        }
        let str = "peak" + String(limit) + "抽出数" + String(ballBox.count)
        DispatchQueue.main.async {self.labelCount.stringValue = str }
        ballBox.shuffle()
        //  表示
        for row in 0...4 {
            let outCell = unPackBall(inDt: ballBox[row])
            for cell in 0...lotoManage.markOfloto - 1{
                lotoManage.mark[row][cell] = outCell[cell]
            }
            for colum in 0...lotoManage.markOfloto - 1{
                let seq = markOfLoto7 * row + colum
                DispatchQueue.main.async {self.markBallMatrix.cells[seq].title = transfromFromZeroToBlank(inDt: lotoManage.mark[row][colum]) }
                if lotoManage.mark[row][colum] > 0{
                    let color:String = "ball" + String(lotoManage.mark[row][colum] % 7)
                    DispatchQueue.main.async {self.markBallMatrix.cells[seq].image =  NSImage(named: color) }
                }else{
                    DispatchQueue.main.async {self.markBallMatrix.cells[seq].image =  NSImage(named: "") }
                }
            }
        }
    }
    
    func packBall(inDt:[Int]) -> Int {
        let ballSet = inDt
        var ballSetInt = 0
        for cell in 0...lotoManage.markOfloto - 1 {
            ballSetInt = ballSetInt + (ballSet[cell] * Int(100^^cell))
        }
        return ballSetInt
    }
    
    func unPackBall(inDt:Int) ->[Int]{
        var ballSet = Array<Int>(repeating: 0,count:lotoManage.markOfloto)
        var remainder = inDt
        for cell in 0...lotoManage.markOfloto - 1 {
            ballSet[cell] = remainder % 100
            remainder = remainder / 100
        }
        return ballSet
    }
}
