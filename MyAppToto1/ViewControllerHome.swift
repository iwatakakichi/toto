//
//  ViewControllerHome.swift
//  totoVer1.0.1
//
//  Created by 岩田嘉吉 on 2017/05/19.
//  Copyright © 2017年 岩田嘉吉. All rights reserved.
//

import Cocoa

class ViewControllerHome: NSViewController {

    @IBOutlet weak var acceptSaleText: NSTextField!
    @IBOutlet weak var salesForecastText: NSTextField!
    @IBOutlet weak var carryOverText: NSTextField!
    @IBOutlet weak var headLineLabel: NSTextField!
    @IBOutlet weak var guidance1Label: NSTextField!
    @IBOutlet weak var guidance2Label: NSTextField!
    @IBOutlet weak var imge1: NSImageView!
    var img1 = NSImage(contentsOfFile: "img1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: "userArray") != nil) {
            homeScreen.user = userDefaults.array(forKey: "userArray") as! Array<Int>
        }
        if (userDefaults.object(forKey: "judgeArray") != nil) {
            managment.userDefault = userDefaults.array(forKey: "judgeArray")  as! Array<Int>
            managment.setJudge()
        }
        acceptSaleText.stringValue = String(homeScreen.user[ch.sale])
        salesForecastText.stringValue = transfromFromZeroToBlank(inDt: homeScreen.user[ch.prospectsSales])
        carryOverText.stringValue = transfromFromZeroToBlank(inDt: homeScreen.user[ch.carryOver])
      
        //  guidance2Label.stringValue = guidance2
        var _ = initializeScreenAndTickets()
        imge1.image = #imageLiteral(resourceName: "img1")
    }
    
    @IBAction func acceptSale(_ sender: Any) {
        //  MARK:開催回アクセプト、購入チケットtikect.csv削除
        homeScreen.user[ch.sale] = Int(acceptSaleText.intValue)
        UserDefaults.standard.set(homeScreen.user, forKey: "userArray")
        var _ = initializeScreenAndTickets()
        var _ = ticketsDelete()
        guidance1Label.stringValue = "前回データを削除しました。"
    }
    
    @IBAction func beforeSale(_ sender: Any) {
        //  MARK:前開催回へ変更
        var counter = homeScreen.user[ch.sale]
        counter = counter - 1
        acceptSaleText.stringValue = String(counter)
        homeScreen.user[ch.sale]  = counter
        UserDefaults.standard.set(homeScreen.user, forKey: "userArray")
        var _ = initializeScreenAndTickets()
        var _ = ticketsDelete()
        guidance1Label.stringValue = "前回データを削除しました。"
    }

    @IBAction func afterSale(_ sender: Any) {
        //  MARK:次開催回へ変更
        var counter = homeScreen.user[ch.sale]
        counter = counter + 1
        acceptSaleText.stringValue = String(counter)
        homeScreen.user[ch.sale] = counter
        UserDefaults.standard.set(homeScreen.user, forKey: "userArray")
        var _ = initializeScreenAndTickets()
        var _ = ticketsDelete()
        guidance1Label.stringValue = "前回データを削除しました。"
    }
    
    @IBAction func acceptSalesForecast(_ sender: Any) {
         //  MARK:売り上げ額アクセプト
        var str = salesForecastText.stringValue
        str = str.replacingOccurrences(of: ",", with: "")
        homeScreen.user[ch.prospectsSales] = transfromFromBlankToZero(inDt:str)
        UserDefaults.standard.set(homeScreen.user, forKey: "userArray")

        managment.judge[cm.prize][cm.high] = Int((Double(homeScreen.user[ch.prospectsSales]) * 0.5 * 0.7 + Double(homeScreen.user[ch.carryOver])) / 10000)
        managment.setUserDefault()
        UserDefaults.standard.set(managment.userDefault, forKey: "judgeArray")
    }
    
    @IBAction func acceptCarryOver(_ sender: Any) {
        //  MARK:キャリーオーバー額アクセプト
        var str = carryOverText.stringValue
        str = str.replacingOccurrences(of: ",", with: "")
        homeScreen.user[ch.carryOver] = transfromFromBlankToZero(inDt:str)
        UserDefaults.standard.set(homeScreen.user, forKey: "userArray")
        
        managment.judge[cm.prize][cm.high] = Int((Double(homeScreen.user[ch.prospectsSales]) * 0.5 * 0.7 + Double(homeScreen.user[ch.carryOver])) / 10000)
        managment.setUserDefault()
        UserDefaults.standard.set(managment.userDefault, forKey: "judgeArray")
    }

    @IBAction func kaisai(_ sender: Any) {
        let _ = totoOfficialSiteDownLoad(sale: String(format: "%04d",homeScreen.user[ch.sale]))
        guidance1Label.stringValue = "販売期間　" + homeScreen.sale
    }

    @IBAction func tohyo(_ sender: Any) {
        //  MARK:トトオフィシャルサイトから投票数を取得
        homeScreen.user[ch.sale] = Int(acceptSaleText.intValue)
        
        if totoOfficialSiteDownLoad(sale: String(format: "%04d",homeScreen.user[ch.sale])) {
            let vote = separateComma(num: (managment.vote[0][0] + managment.vote[0][1] + managment.vote[0][2]) * 100)
            headLineLabel.stringValue = "投票状況　" + vote + "円"
        }else{
            guidance1Label.stringValue = "ご指定の投票状況は表示できません。"
        }
    }
    
    @IBAction func result(_ sender: Any) {
        //  MARK:トトオフィシャルサイトから試合結果を取得
        headLineLabel.stringValue = ""
        guidance1Label.stringValue = ""
        
        if lotteryResultDownLoad(sale: homeScreen.user[ch.sale]) &&
            totoOfficialSiteDownLoad(sale: String(format: "%04d",homeScreen.user[ch.sale])){
            let vote = separateComma(num: (managment.vote[0][0] + managment.vote[0][1] + managment.vote[0][2]) * 100)
            headLineLabel.stringValue = "投票状況　" + vote + "円"
            var rezult = "くじ結果: "
            for i in homeScreen.matchResult {
                rezult = rezult + String(i)
            }
            rezult = rezult + "　　 一等賞金 " + separateComma(num: homeScreen.prize) + "円"
            guidance1Label.stringValue = rezult
            multiView.prize = Int(homeScreen.prize)
        }else{
            guidance1Label.stringValue = "ご指定のくじ結果は表示できません。"
        }
    }
    
    func initializeScreenAndTickets() {
        firstOrderTickets.removeAll()
        buyTickets.removeAll()
        managment.initialize()
        homeScreen.matchResult = Array<Int>(repeating: 0,count:13)
        multSCreen.initialize()
        multiView.goDraw = cd.erase
        multSCreen.stamp += 1
        singleScreen.stamp += 1
        checkScreen.stamp += 1
    }
}
